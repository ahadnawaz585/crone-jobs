#!/bin/bash

# Load environment variables
source $(dirname "$0")/load_env.sh

# Create timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
MAIN_LOG_FILE="${BASE_DIR}/main_backups.log"

echo ">>== Weekly database backups started: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"

for db_key in ${!DBs[@]}; do
    DB_NAME="${DBs[${db_key}]}"

    DB_DIR="${BASE_DIR}/${db_key}"
    WEEKLY_DIR="${DB_DIR}/weekly"
    WEEKLY_LOG="${WEEKLY_DIR}/weekly_backup.log"
    
    # Create directories if they don't exist
    mkdir -p "${WEEKLY_DIR}"
    touch "$WEEKLY_LOG"

    FILE_NAME="${DB_NAME}_${TIMESTAMP}.sql"
    GZIP_NAME="${DB_NAME}_${TIMESTAMP}.sql.gz"

    echo "$(date +"%F %T.%3N"): Starting weekly backup for ${DB_NAME}..." >> "$WEEKLY_LOG"

    # Run pg_dump
    export PGPASSWORD="$DB_PASSWORD"
    pg_dump -h "$DB_HOST" -U "$DB_USER" --no-owner -p "$DB_PORT" "$DB_NAME" > "${WEEKLY_DIR}/${FILE_NAME}"
    BACKUP_STATUS=$?
    unset PGPASSWORD

    if [ $BACKUP_STATUS -ne 0 ]; then
        echo "$(date +"%F %T.%3N"): ERROR - Weekly backup failed for ${DB_NAME} with status $BACKUP_STATUS" >> "$WEEKLY_LOG"
        echo "ERROR - Weekly backup failed for ${DB_NAME}: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
        continue
    fi

    # Compress the backup
    gzip "${WEEKLY_DIR}/${FILE_NAME}"
    COMPRESS_STATUS=$?

    if [ $COMPRESS_STATUS -ne 0 ]; then
        echo "$(date +"%F %T.%3N"): ERROR - Compression failed for ${DB_NAME} with status $COMPRESS_STATUS" >> "$WEEKLY_LOG"
        echo "ERROR - Compression failed for ${DB_NAME}: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
        continue
    fi

    BACKUP_SIZE=$(du -h "${WEEKLY_DIR}/${GZIP_NAME}" | cut -f1)
    echo "$(date +"%F %T.%3N"): Created weekly backup for ${DB_NAME}: ${GZIP_NAME} (${BACKUP_SIZE})" >> "$WEEKLY_LOG"
    echo "${DB_NAME} weekly backup completed: ${BACKUP_SIZE}" >> "$MAIN_LOG_FILE"

    echo "$(date +"%F %T.%3N"): Weekly backup process for ${DB_NAME} completed successfully" >> "$WEEKLY_LOG"
    echo "------------------------------------------------------" >> "$WEEKLY_LOG"
done

echo "<<== Weekly database backups completed: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
echo "" >> "$MAIN_LOG_FILE"