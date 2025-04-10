#!/bin/bash

# Load environment variables
source $(dirname "$0")/load_env.sh

# Create timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
MAIN_LOG_FILE="${BASE_DIR}/main_backups.log"

echo ">>== Yearly database backups started: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"

for db_key in ${!DBs[@]}; do
    DB_NAME="${DBs[${db_key}]}"

    DB_DIR="${BASE_DIR}/${db_key}"
    YEARLY_DIR="${DB_DIR}/yearly"
    YEARLY_LOG="${YEARLY_DIR}/yearly_backup.log"
    
    # Create directories if they don't exist
    mkdir -p "${YEARLY_DIR}"
    touch "$YEARLY_LOG"

    FILE_NAME="${DB_NAME}_${TIMESTAMP}.sql"
    GZIP_NAME="${DB_NAME}_${TIMESTAMP}.sql.gz"

    echo "$(date +"%F %T.%3N"): Starting yearly backup for ${DB_NAME}..." >> "$YEARLY_LOG"

    # Run pg_dump
    export PGPASSWORD="$DB_PASSWORD"
    pg_dump -h "$DB_HOST" -U "$DB_USER" --no-owner -p "$DB_PORT" "$DB_NAME" > "${YEARLY_DIR}/${FILE_NAME}"
    BACKUP_STATUS=$?
    unset PGPASSWORD

    if [ $BACKUP_STATUS -ne 0 ]; then
        echo "$(date +"%F %T.%3N"): ERROR - Yearly backup failed for ${DB_NAME} with status $BACKUP_STATUS" >> "$YEARLY_LOG"
        echo "ERROR - Yearly backup failed for ${DB_NAME}: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
        continue
    fi

    # Compress the backup
    gzip "${YEARLY_DIR}/${FILE_NAME}"
    COMPRESS_STATUS=$?

    if [ $COMPRESS_STATUS -ne 0 ]; then
        echo "$(date +"%F %T.%3N"): ERROR - Compression failed for ${DB_NAME} with status $COMPRESS_STATUS" >> "$YEARLY_LOG"
        echo "ERROR - Compression failed for ${DB_NAME}: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
        continue
    fi

    BACKUP_SIZE=$(du -h "${YEARLY_DIR}/${GZIP_NAME}" | cut -f1)
    echo "$(date +"%F %T.%3N"): Created yearly backup for ${DB_NAME}: ${GZIP_NAME} (${BACKUP_SIZE})" >> "$YEARLY_LOG"
    echo "${DB_NAME} yearly backup completed: ${BACKUP_SIZE}" >> "$MAIN_LOG_FILE"

    echo "$(date +"%F %T.%3N"): Yearly backup process for ${DB_NAME} completed successfully" >> "$YEARLY_LOG"
    echo "------------------------------------------------------" >> "$YEARLY_LOG"
done

echo "<<== Yearly database backups completed: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
echo "" >> "$MAIN_LOG_FILE"