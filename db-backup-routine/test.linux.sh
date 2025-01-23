#!/bin/bash

OUTPUT_DIR=""
LOG_FILE=""
mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

DB_NAME=""
DB_USER=""
DB_PASSWORD='' 
DB_HOST=""
DB_PORT=""

FILE_NAME="database_dump_${TIMESTAMP}.sql"
GZIP_NAME="database_dump_${TIMESTAMP}.sql.gz"

export PGPASSWORD="$DB_PASSWORD"

pg_dump -h "$DB_HOST" -U "$DB_USER" -p "$DB_PORT" "$DB_NAME" > "$OUTPUT_DIR/$FILE_NAME"

gzip "$OUTPUT_DIR/$FILE_NAME"

echo "$(date +"%Y-%m-%d %H:%M:%S") - Database dump has been created and compressed into $GZIP_NAME in $OUTPUT_DIR" >> "$LOG_FILE"

unset PGPASSWORD

MINUTE=$(date +"%M")
HOUR=$(date +"%H")

if (( MINUTE == 0 && HOUR % 3 == 0 )); then
  FILES=("$OUTPUT_DIR"/*.gz)

  for FILE in "${FILES[@]}"; do
    FILE_MINUTE=$(date -r "$FILE" +"%M")
    FILE_HOUR=$(date -r "$FILE" +"%H")
    if (( FILE_MINUTE != 0 || FILE_HOUR % 3 != 0 )); then
      rm "$FILE"
      echo "$(date +"%Y-%m-%d %H:%M:%S") - Deleted: $FILE (Hour not a multiple of 3 or Minute not 00)" >> "$LOG_FILE"
    fi
  done
elif (( MINUTE == 0 )); then
  FILES=("$OUTPUT_DIR"/*.gz)

  for FILE in "${FILES[@]}"; do
    FILE_MINUTE=$(date -r "$FILE" +"%M")
    if (( FILE_MINUTE != 0 )); then
      rm "$FILE"
      echo "$(date +"%Y-%m-%d %H:%M:%S") - Deleted: $FILE (Minute not 00)" >> "$LOG_FILE"
    fi
  done
elif (( MINUTE % 5 == 0 )); then
  FILES=("$OUTPUT_DIR"/*.gz)

  for FILE in "${FILES[@]}"; do
    FILE_MINUTE=$(date -r "$FILE" +"%-M")
    if (( FILE_MINUTE % 5 != 0 )); then
      rm "$FILE"
      echo "$(date +"%Y-%m-%d %H:%M:%S") - Deleted: $FILE (Minute not a multiple of 5)" >> "$LOG_FILE"
    fi
  done
fi
