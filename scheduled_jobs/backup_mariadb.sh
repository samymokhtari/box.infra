#!/usr/bin/env bash

# Create the backup directory if it doesn't already exist
HOST_BACKUP_DIR="/backups/mariadb"
sudo mkdir -p $HOST_BACKUP_DIR
sudo chmod +rwx $HOST_BACKUP_DIR

### Clean up old backups

MAX_BACKUPS=7 # Number of backups to keep

# Navigate to the backup directory
cd "$HOST_BACKUP_DIR" || { echo "Backup directory not found: $HOST_BACKUP_DIR"; exit 1; }

# Ensure only readable directories or .tar.gz files are processed
# Process directories first
find "$HOST_BACKUP_DIR" -maxdepth 1 -type d -name 'export-*' -readable -print0 | \
sort -rz | \
tail -zn +$((MAX_BACKUPS + 1)) | \
while IFS= read -r -d '' OLD_BACKUP_DIR; do
  echo "Deleting old backup directory: $OLD_BACKUP_DIR"
  rm -rf "$OLD_BACKUP_DIR" || echo "Failed to delete directory $OLD_BACKUP_DIR"
done

# Process tar.gz files
find "$HOST_BACKUP_DIR" -maxdepth 1 -type f -name '*.tar.gz' -readable -print0 | \
sort -rz | \
tail -zn +$((MAX_BACKUPS + 1)) | \
while IFS= read -r -d '' OLD_BACKUP_FILE; do
  echo "Deleting old backup file: $OLD_BACKUP_FILE"
  rm -f "$OLD_BACKUP_FILE" || echo "Failed to delete file $OLD_BACKUP_FILE"
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
  else
    echo "Error: Backup failed for container: $CONTAINER"
    # Return failure code
    exit $?
  fi

  # Compress the backup
  echo "Compressing backup by creating a tar file..."
  BACKUP_FILE="${CONTAINER}_$(date +%Y%m%d%H%M%S).tar.gz"
  tar -czvf $HOST_BACKUP_DIR/$BACKUP_FILE $HOST_BACKUP_DIR/$(ls $HOST_BACKUP_DIR | grep $CONTAINER | head -n 1)
  echo "Backup compressed successfully as: $BACKUP_FILE"

done

exit 0

