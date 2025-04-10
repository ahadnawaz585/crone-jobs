#!/bin/bash

OUTPUT_DIR=""
LOG_FILE=""
mkdir -p "$OUTPUT_DIR"

# Create a timestamped database dump
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DB_NAME=""
DB_USER=""
DB_PASSWORD='' # Provide the password here
DB_HOST=""
DB_PORT=""

FILE_NAME="bss_upvccloud_dump_${TIMESTAMP}.sql"
GZIP_NAME="bss_upvccloud_dump_${TIMESTAMP}.sql.gz"
export PGPASSWORD="$DB_PASSWORD"
pg_dump -h "$DB_HOST" -U "$DB_USER" --no-owner -p "$DB_PORT" "$DB_NAME" > "$OUTPUT_DIR/$FILE_NAME"

unset PGPASSWORD

gzip "$OUTPUT_DIR/$FILE_NAME"

echo "Database dump has been created and compressed into $GZIP_NAME in $OUTPUT_DIR" >> "$LOG_FILE"

# Define time variables (strip leading zeros using `%-` format specifiers)
MINUTE=$(date +"%-M")
HOUR=$(date +"%-H")
DAY=$(date +"%-u")
DATE=$(date +"%-d")
WEEK=$(date +"%-W")
MONTH=$(date +"%-m")
YEAR=$(date +"%-Y")

# Retention logic
if (( MINUTE == 0 && HOUR % 3 == 0 )); then
  # Keep 8 backups in a day (every 3 hours)
  FILES=("$OUTPUT_DIR"/*.gz)
  for FILE in "${FILES[@]}"; do
    FILE_HOUR=$(date -r "$FILE" +"%-H")
    if (( FILE_HOUR % 3 != 0 )); then
      rm "$FILE"
      echo "Deleted: $FILE (Hour not a multiple of 3)" >> "$LOG_FILE"
    fi
  done
fi

if (( MINUTE == 0 && HOUR == 0 )); then
  # Keep 7 daily backups (1 per day at 00:00)
  FILES=("$OUTPUT_DIR"/*.gz)
  for FILE in "${FILES[@]}"; do
    FILE_DAY=$(date -r "$FILE" +"%-u")
    if (( FILE_DAY < DAY - 6 || FILE_DAY > DAY )); then
      rm "$FILE"
      echo "Deleted: $FILE (Older than 7 days)" >> "$LOG_FILE"
    fi
  done
fi

if (( MINUTE == 0 && HOUR == 0 && DAY == 7 )); then
  # Keep 4 weekly backups (1 per week on Sunday at 00:00)
  FILES=("$OUTPUT_DIR"/*.gz)
  for FILE in "${FILES[@]}"; do
    FILE_WEEK=$(date -r "$FILE" +"%-W")
    if (( FILE_WEEK < WEEK - 3 )); then
      rm "$FILE"
      echo "Deleted: $FILE (Older than 4 weeks)" >> "$LOG_FILE"
    fi
  done
fi

if (( MINUTE == 0 && HOUR == 0 && DATE == 1 )); then
  # Keep 12 monthly backups (1 per month on the 1st at 00:00)
  FILES=("$OUTPUT_DIR"/*.gz)
  for FILE in "${FILES[@]}"; do
    FILE_MONTH=$(date -r "$FILE" +"%-m")
    FILE_YEAR=$(date -r "$FILE" +"%-Y")
    if (( FILE_YEAR < YEAR || FILE_MONTH < MONTH - 11 )); then
      rm "$FILE"
      echo "Deleted: $FILE (Older than 12 months)" >> "$LOG_FILE"
    fi
  done
fi
