#!/bin/bash

# Load environment variables
source $(dirname "$0")/load_env.sh

MAIN_LOG_FILE="${BASE_DIR}/main_backups.log"

# Create main log file
touch "$MAIN_LOG_FILE"

echo "Creating backup directory structure..." | tee -a "$MAIN_LOG_FILE"

for db_key in ${!DBs[@]}; do
    DB_DIR="${BASE_DIR}/${db_key}"
    
    # Create the directory structure
    mkdir -p "${DB_DIR}/hourly"
    mkdir -p "${DB_DIR}/daily"
    mkdir -p "${DB_DIR}/weekly"
    mkdir -p "${DB_DIR}/monthly"
    mkdir -p "${DB_DIR}/yearly"
    
    # Create log files for each directory
    touch "${DB_DIR}/hourly/hourly_backup.log"
    touch "${DB_DIR}/daily/daily_backup.log"
    touch "${DB_DIR}/weekly/weekly_backup.log"
    touch "${DB_DIR}/monthly/monthly_backup.log"
    touch "${DB_DIR}/yearly/yearly_backup.log"
    touch "${DB_DIR}/cleanup.log"
    
    echo "Created directories and log files for ${db_key}" | tee -a "$MAIN_LOG_FILE"
done

echo "Backup directory structure has been set up." | tee -a "$MAIN_LOG_FILE"
echo "Don't forget to set up cron jobs for each backup type!" | tee -a "$MAIN_LOG_FILE"