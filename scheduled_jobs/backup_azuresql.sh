#!/bin/bash

# Source the .env file to load environment variables
if [ -f .env ]; then
  source .env
else
  echo "Error: .env file not found."
  exit 1
fi

# Variables
CONTAINER_NAME="azure-sql-edge"      # Container name from your configuration
DATABASES=("box" "sonar")        # Array of database names to back up
BACKUP_DIR="/var/opt/mssql/backups" # Directory inside the container for backups
HOST_BACKUP_DIR="/backups/mssql"    # Directory on the host mapped to container backup dir
SA_PASSWORD="${MSSQL_SA_PASSWORD}"  # Retrieve the SA password from the environment

# Ensure the host backup directory exists
sudo mkdir -p "$HOST_BACKUP_DIR"

# Iterate over the databases array and back up each one
for DB_NAME in "${DATABASES[@]}"; do
  BACKUP_FILE="${DB_NAME}_$(date +%Y%m%d%H%M%S).bak" # Backup file with timestamp

  echo "Starting backup of database $DB_NAME..."
  docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$SA_PASSWORD" \
  -Q "BACKUP DATABASE [$DB_NAME] TO DISK = N'$BACKUP_DIR/$BACKUP_FILE' WITH NOFORMAT, NOINIT, NAME = N'$DB_NAME-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, COMPRESSION, STATS = 10;"

  # Check if the backup was successful
  if [ $? -eq 0 ]; then
    echo "Backup of database $DB_NAME completed successfully."
    echo "Backup file: $HOST_BACKUP_DIR/$BACKUP_FILE"
  else
    echo "Error: Backup of database $DB_NAME failed."
    exit 1
  fi
done

echo "All backups completed successfully."
exit 0
