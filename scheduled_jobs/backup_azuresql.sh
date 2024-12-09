#!/bin/bash

# Load environment variables from the .env file
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# Configuration Variables
CONTAINER_NAME="azure-sql-edge"      # Name of the Azure SQL Edge container
DATABASES=("box" "sonar")            # List of databases to back up
BACKUP_DIR="/var/opt/mssql/backups"  # Backup directory inside the container
HOST_BACKUP_DIR="/backups/mssql"     # Backup directory on the host system
MAX_BACKUPS=7                        # Number of backups to retain
SA_PASSWORD="${MSSQL_SA_PASSWORD}"   # Retrieve SA password from the environment

# Ensure the host backup directory exists
sudo mkdir -p "$HOST_BACKUP_DIR"
sudo chmod +rwx "$HOST_BACKUP_DIR"

# Cleanup old backups
echo "Cleaning up old backups..."
cd "$HOST_BACKUP_DIR" || { echo "Error: Backup directory not found: $HOST_BACKUP_DIR"; exit 1; }

# Find and remove older backups beyond the MAX_BACKUPS limit
find "$HOST_BACKUP_DIR" -maxdepth 1 -type f -name '*.bak' -readable -print0 | \
sort -rz | \
tail -zn +$((MAX_BACKUPS + 1)) | \
while IFS= read -r -d '' OLD_BACKUP; do
  echo "Deleting old backup: $OLD_BACKUP"
  rm -f "$OLD_BACKUP" || echo "Failed to delete $OLD_BACKUP"
done

echo "Old backup cleanup complete. Retained the latest $MAX_BACKUPS backups."

# Backup each database
for DB_NAME in "${DATABASES[@]}"; do
  BACKUP_FILE="${DB_NAME}_$(date +%Y%m%d%H%M%S).bak" # Backup file with timestamp

  echo "Starting backup of database $DB_NAME..."
  docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" \
  -Q "BACKUP DATABASE [$DB_NAME] TO DISK = N'$BACKUP_DIR/$BACKUP_FILE' WITH NOFORMAT, NOINIT, NAME = N'$DB_NAME-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10;"

  # Check if the backup was successful
  if [ $? -eq 0 ]; then
    echo "Backup of database $DB_NAME completed successfully."
    # Move the backup file to the host directory
    docker cp "$CONTAINER_NAME:$BACKUP_DIR/$BACKUP_FILE" "$HOST_BACKUP_DIR/" && \
    echo "Backup file moved to: $HOST_BACKUP_DIR/$BACKUP_FILE"
  else
    echo "Error: Backup of database $DB_NAME failed."
    exit 1
  fi
done

echo "All backups completed successfully."
exit 0
