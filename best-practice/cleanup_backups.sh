#!/bin/bash

# Load environment variables
source $(dirname "$0")/load_env.sh

MAIN_LOG_FILE="${BASE_DIR}/main_backups.log"

echo ">>== Database backup cleanup started: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"

for db_key in ${!DBs[@]}; do
    DB_NAME="${DBs[${db_key}]}"
    DB_DIR="${BASE_DIR}/${db_key}"
    
    # Define directories
    HOURLY_DIR="${DB_DIR}/hourly"
    DAILY_DIR="${DB_DIR}/daily"
    WEEKLY_DIR="${DB_DIR}/weekly"
    MONTHLY_DIR="${DB_DIR}/monthly"
    YEARLY_DIR="${DB_DIR}/yearly"
    
    # Define log files
    HOURLY_LOG="${HOURLY_DIR}/hourly_backup.log"
    DAILY_LOG="${DAILY_DIR}/daily_backup.log"
    WEEKLY_LOG="${WEEKLY_DIR}/weekly_backup.log"
    MONTHLY_LOG="${MONTHLY_DIR}/monthly_backup.log"
    YEARLY_LOG="${YEARLY_DIR}/yearly_backup.log"
    CLEANUP_LOG="${DB_DIR}/cleanup.log"
    
    # Create cleanup log if it doesn't exist
    touch "$CLEANUP_LOG"
    
    echo "$(date +"%F %T.%3N"): Starting cleanup for ${DB_NAME}..." >> "$CLEANUP_LOG"
    
    # Clean up hourly backups
    echo "$(date +"%F %T.%3N"): Cleaning up hourly backups..." >> "$CLEANUP_LOG"
    HOURLY_COUNT=$(find "${HOURLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | wc -l)
    if [ $HOURLY_COUNT -gt $HOURLY_RETENTION ]; then
        find "${HOURLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -$HOURLY_RETENTION | xargs -r rm
        DELETED=$((HOURLY_COUNT - HOURLY_RETENTION))
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old hourly backups, keeping $HOURLY_RETENTION recent ones" >> "$CLEANUP_LOG"
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old hourly backups" >> "$HOURLY_LOG"
    else
        echo "$(date +"%F %T.%3N"): No hourly backups to clean up (have $HOURLY_COUNT, keeping $HOURLY_RETENTION)" >> "$CLEANUP_LOG"
    fi
    
    # Clean up daily backups
    echo "$(date +"%F %T.%3N"): Cleaning up daily backups..." >> "$CLEANUP_LOG"
    DAILY_COUNT=$(find "${DAILY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | wc -l)
    if [ $DAILY_COUNT -gt $DAILY_RETENTION ]; then
        find "${DAILY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -$DAILY_RETENTION | xargs -r rm
        DELETED=$((DAILY_COUNT - DAILY_RETENTION))
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old daily backups, keeping $DAILY_RETENTION recent ones" >> "$CLEANUP_LOG"
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old daily backups" >> "$DAILY_LOG"
    else
        echo "$(date +"%F %T.%3N"): No daily backups to clean up (have $DAILY_COUNT, keeping $DAILY_RETENTION)" >> "$CLEANUP_LOG"
    fi
    
    # Clean up weekly backups
    echo "$(date +"%F %T.%3N"): Cleaning up weekly backups..." >> "$CLEANUP_LOG"
    WEEKLY_COUNT=$(find "${WEEKLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | wc -l)
    if [ $WEEKLY_COUNT -gt $WEEKLY_RETENTION ]; then
        find "${WEEKLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -$WEEKLY_RETENTION | xargs -r rm
        DELETED=$((WEEKLY_COUNT - WEEKLY_RETENTION))
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old weekly backups, keeping $WEEKLY_RETENTION recent ones" >> "$CLEANUP_LOG"
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old weekly backups" >> "$WEEKLY_LOG"
    else
        echo "$(date +"%F %T.%3N"): No weekly backups to clean up (have $WEEKLY_COUNT, keeping $WEEKLY_RETENTION)" >> "$CLEANUP_LOG"
    fi
    
    # Clean up monthly backups
    echo "$(date +"%F %T.%3N"): Cleaning up monthly backups..." >> "$CLEANUP_LOG"
    MONTHLY_COUNT=$(find "${MONTHLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | wc -l)
    if [ $MONTHLY_COUNT -gt $MONTHLY_RETENTION ]; then
        find "${MONTHLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -$MONTHLY_RETENTION | xargs -r rm
        DELETED=$((MONTHLY_COUNT - MONTHLY_RETENTION))
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old monthly backups, keeping $MONTHLY_RETENTION recent ones" >> "$CLEANUP_LOG"
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old monthly backups" >> "$MONTHLY_LOG"
    else
        echo "$(date +"%F %T.%3N"): No monthly backups to clean up (have $MONTHLY_COUNT, keeping $MONTHLY_RETENTION)" >> "$CLEANUP_LOG"
    fi
    
    # Clean up yearly backups
    echo "$(date +"%F %T.%3N"): Cleaning up yearly backups..." >> "$CLEANUP_LOG"
    YEARLY_COUNT=$(find "${YEARLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | wc -l)
    if [ $YEARLY_COUNT -gt $YEARLY_RETENTION ]; then
        find "${YEARLY_DIR}" -name "${DB_NAME}_*.sql.gz" -type f | sort | head -n -$YEARLY_RETENTION | xargs -r rm
        DELETED=$((YEARLY_COUNT - $YEARLY_RETENTION))
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old yearly backups, keeping $YEARLY_RETENTION recent ones" >> "$CLEANUP_LOG"
        echo "$(date +"%F %T.%3N"): Deleted $DELETED old yearly backups" >> "$YEARLY_LOG"
    else
        echo "$(date +"%F %T.%3N"): No yearly backups to clean up (have $YEARLY_COUNT, keeping $YEARLY_RETENTION)" >> "$CLEANUP_LOG"
    fi
    
    echo "$(date +"%F %T.%3N"): Cleanup completed for ${DB_NAME}" >> "$CLEANUP_LOG"
    echo "------------------------------------------------------" >> "$CLEANUP_LOG"
    echo "Cleanup completed for ${DB_NAME}" >> "$MAIN_LOG_FILE"
done

echo "<<== Database backup cleanup completed: $(date +"%F %T.%3N")" >> "$MAIN_LOG_FILE"
echo "" >> "$MAIN_LOG_FILE"