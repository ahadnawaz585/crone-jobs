
BASE_DIR="/home/ubuntu/db_backups"
MAIN_LOG_FILE="${BASE_DIR}/backups.log"

mkdir -p "$BASE_DIR"


declare -A DBs
DBs["aman"]="aman_upvccloud"
DBs["upvc"]="bpc_upvccloud"
DBs["qwin"]="qwin_upvccloud"
DBs["windowinnovations"]="windowinnovations_upvccloud"
DBs["skyline"]="skyline_upvccloud"

DB_USER="appuser"
DB_PASSWORD='75$UC7#ua@5'
DB_HOST="localhost"
DB_PORT="5432"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
HOUR=$(date +"%H")
DAYOFWEEK=$(date +"%u")   
DAYOFMONTH=$(date +"%d")
MONTH=$(date +"%m")

echo ">>== Database backups started: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"


for db_key in ${!DBs[@]}; do
    DB_NAME="${DBs[${db_key}]}"
    
    DB_DIR="${BASE_DIR}/${db_key}"
    HOURLY_DIR="${DB_DIR}/hourly"
    DAILY_DIR="${DB_DIR}/daily"
    WEEKLY_DIR="${DB_DIR}/weekly"
    MONTHLY_DIR="${DB_DIR}/monthly"
    YEARLY_DIR="${DB_DIR}/yearly"
    DB_LOG_FILE="${DB_DIR}/backup.log"
    

    mkdir -p "${HOURLY_DIR}" "${DAILY_DIR}" "${WEEKLY_DIR}" "${MONTHLY_DIR}" "${YEARLY_DIR}"
    

    FILE_NAME="${DB_NAME}_${TIMESTAMP}.sql"
    GZIP_NAME="${DB_NAME}_${TIMESTAMP}.sql.gz"
    

    echo "$(date +"%F %T.%3N"): Starting backup for ${DB_NAME}..." >> "$DB_LOG_FILE"
    

    export PGPASSWORD="$DB_PASSWORD"
    pg_dump -h "$DB_HOST" -U "$DB_USER" --no-owner -p "$DB_PORT" "$DB_NAME" > "${HOURLY_DIR}/${FILE_NAME}"
    BACKUP_STATUS=$?
    unset PGPASSWORD
    

    if [ $BACKUP_STATUS -ne 0 ]; then
        echo "$(date +"%F %T.%3N"): ERROR - Backup failed for ${DB_NAME} with status $BACKUP_STATUS" >> "$DB_LOG_FILE"
        echo "ERROR - Backup failed for ${DB_NAME}: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
        continue
    fi
    

    gzip "${HOURLY_DIR}/${FILE_NAME}"
    COMPRESS_STATUS=$?
    
    if [ $COMPRESS_STATUS -ne 0 ]; then
        echo "$(date +"%F %T.%3N"): ERROR - Compression failed for ${DB_NAME} with status $COMPRESS_STATUS" >> "$DB_LOG_FILE"
        echo "ERROR - Compression failed for ${DB_NAME}: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
        continue
    fi
    

    BACKUP_SIZE=$(du -h "${HOURLY_DIR}/${GZIP_NAME}" | cut -f1)
    echo "$(date +"%F %T.%3N"): Created hourly backup for ${DB_NAME}: ${GZIP_NAME} (${BACKUP_SIZE})" >> "$DB_LOG_FILE"
    echo "${DB_NAME} backup completed: ${BACKUP_SIZE}" >> "$MAIN_LOG_FILE"
    

    if [ "$HOUR" == "00" ]; then
        cp "${HOURLY_DIR}/${GZIP_NAME}" "${DAILY_DIR}/"
        echo "$(date +"%F %T.%3N"): Copied to daily backup: ${DAILY_DIR}/${GZIP_NAME}" >> "$DB_LOG_FILE"
        
        # Keep only the 7 most recent daily backups
        find "${DAILY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -7 | xargs -r rm
        echo "$(date +"%F %T.%3N"): Cleaned up old daily backups, keeping only the last 7 days" >> "$DB_LOG_FILE"
    fi
    

    if [ "$HOUR" == "00" ] && [ "$DAYOFWEEK" == "7" ]; then
        cp "${HOURLY_DIR}/${GZIP_NAME}" "${WEEKLY_DIR}/"
        echo "$(date +"%F %T.%3N"): Copied to weekly backup: ${WEEKLY_DIR}/${GZIP_NAME}" >> "$DB_LOG_FILE"
        
        # Keep only the 4 most recent weekly backups
        find "${WEEKLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -4 | xargs -r rm
        echo "$(date +"%F %T.%3N"): Cleaned up old weekly backups, keeping only the last 4 weeks" >> "$DB_LOG_FILE"
    fi
    

    if [ "$HOUR" == "00" ] && [ "$DAYOFMONTH" == "01" ]; then
        cp "${HOURLY_DIR}/${GZIP_NAME}" "${MONTHLY_DIR}/"
        echo "$(date +"%F %T.%3N"): Copied to monthly backup: ${MONTHLY_DIR}/${GZIP_NAME}" >> "$DB_LOG_FILE"
        
        # Keep only the 12 most recent monthly backups
        find "${MONTHLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -12 | xargs -r rm
        echo "$(date +"%F %T.%3N"): Cleaned up old monthly backups, keeping only the last 12 months" >> "$DB_LOG_FILE"
    fi
    

    if [ "$HOUR" == "00" ] && [ "$DAYOFMONTH" == "01" ] && [ "$MONTH" == "01" ]; then
        cp "${HOURLY_DIR}/${GZIP_NAME}" "${YEARLY_DIR}/"
        echo "$(date +"%F %T.%3N"): Copied to yearly backup: ${YEARLY_DIR}/${GZIP_NAME}" >> "$DB_LOG_FILE"
        
        # Keep the 5 most recent yearly backups
        find "${YEARLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -5 | xargs -r rm
        echo "$(date +"%F %T.%3N"): Cleaned up old yearly backups, keeping only the last 5 years" >> "$DB_LOG_FILE"
    fi
    

    find "${HOURLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -8 | xargs -r rm
    echo "$(date +"%F %T.%3N"): Cleaned up old hourly backups, keeping the 8 most recent" >> "$DB_LOG_FILE"
    
    echo "$(date +"%F %T.%3N"): Backup process for ${DB_NAME} completed successfully" >> "$DB_LOG_FILE"
    echo "------------------------------------------------------" >> "$DB_LOG_FILE"
done

echo "<<== Database backups completed: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
echo "" >> "$MAIN_LOG_FILE"