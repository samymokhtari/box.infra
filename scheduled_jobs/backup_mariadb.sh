#!/usr/bin/env bash

# Create the backup directory if it doesn't already exist
HOST_BACKUP_DIR="/backups/mariadb"
sudo mkdir -p $HOST_BACKUP_DIR
sudo chmod +rwx $HOST_BACKUP_DIR

### Clean up old backups

MAX_BACKUPS=7 # Number of backups to keep

# Navigate to the backup directory
cd "$HOST_BACKUP_DIR" || { echo "Backup directory not found: $HOST_BACKUP_DIR"; exit 1; }

# Ensure only readable files are processed
find "$HOST_BACKUP_DIR" -maxdepth 1 -type f -name 'export-*.sql' -readable -print0 | \
sort -rz | \
tail -zn +$((MAX_BACKUPS + 1)) | \
while IFS= read -r -d '' OLD_BACKUP; do
  echo "Deleting old backup: $OLD_BACKUP"
  rm -f "$OLD_BACKUP" || echo "Failed to delete $OLD_BACKUP"
done

echo "Backup pruning complete. Only the latest $MAX_BACKUPS backups are kept."

### Start the MariaDB backup

echo "Starting MariaDB backup..."
# Pull the latest version of the mariadb-backup Docker image
docker pull registry.gitlab.com/ix.ai/mariadb-backup:latest

# Loop through all containers labeled with "mariadb-backup"
for CONTAINER in $(docker ps -f label=mariadb-backup --format='{{.Names}}'); do
  echo "Processing container: $CONTAINER"

  # Extract the MariaDB root password from the container's environment variables
  DB_PASS=$(docker inspect ${CONTAINER} | jq -r '.[0].Config.Env[] | select(test("^MARIADB_ROOT_PASSWORD=.*"))' | sed -n 's/^MARIADB_ROOT_PASSWORD=\(.*\)/\1/p')
  if [[ -z "$DB_PASS" ]]; then
    echo "Error: MARIADB_ROOT_PASSWORD not set for container $CONTAINER. Skipping..."
    continue
  fi

  # Extract the container's network name
  DB_NET=$(docker inspect ${CONTAINER} | jq -r '.[0].NetworkSettings.Networks | to_entries[] | .key')
  if [[ -z "$DB_NET" ]]; then
    echo "Error: No network found for container $CONTAINER. Skipping..."
    continue
  fi

  # Run the backup command for the current container
  echo "Starting backup for container: $CONTAINER"
  docker run --rm --name ${CONTAINER}-backup \
    -e DB_PASS=${DB_PASS} \
    -e DB_HOST=${CONTAINER} \
    --network ${DB_NET} \
    -v $HOST_BACKUP_DIR:/backup \
    registry.gitlab.com/ix.ai/mariadb-backup:latest

  # Check the result of the backup command
  if [[ $? -eq 0 ]]; then
    echo "Backup completed successfully for container: $CONTAINER"
    # Return success code
    exit 0
  else
    echo "Error: Backup failed for container: $CONTAINER"
    # Return failure code
    exit $?
  fi

done
