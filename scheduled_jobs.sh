#!/bin/bash

# Set the date for the backup file
backup_date=$(date +"%Y%m%d%H%M%S")

# Set the directory to store backups
backup_dir="/home/backups/mariadb"

# Set the container name
container_name="mariadb"

# Set the root password for MariaDB
mariadb_root_password="$MARIADB_ROOT_PASSWORD"
mariadb_root_password="$MARIADB_ROOT_USERNAME"

# Set the filename for the backup
backup_file="${backup_dir}/mariadb_backup_${backup_date}.sql"

# Run the backup command
docker exec ${container_name} mariadb-dump --all-databases -u"${MARIADB_ROOT_USERNAME}" -p"${mariadb_root_password}" > "${backup_file}"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup completed successfully. File: ${backup_file}"
else
  echo "Backup failed. Please check the logs for more information."
fi
