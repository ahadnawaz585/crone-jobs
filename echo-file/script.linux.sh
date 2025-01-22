#!/bin/bash

# Set variables for file paths
OUTPUT_DIR="/home/ahad/codes/logs"  # Replace with your desired directory

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_NAME="life_message_${TIMESTAMP}.txt"
GZIP_NAME="life_message_${TIMESTAMP}.txt.gz"

# Create the text file
echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"

# Compress the file using gzip
gzip "$OUTPUT_DIR/$FILE_NAME"

# Confirm completion
echo "Message has been saved and compressed into $GZIP_NAME in $OUTPUT_DIR"

# Cleanup: Keep only files created at 5-minute intervals
CURRENT_MIN=$(date "+%M")

if (( CURRENT_MIN % 5 == 0 )); then
  echo "File for minute $CURRENT_MIN is being kept."
else
  echo "File for minute $CURRENT_MIN is being deleted."
  rm -f "$OUTPUT_DIR/$GZIP_NAME"
fi

# Final cleanup: Retain only the last 5 gzipped files
cd "$OUTPUT_DIR" || exit
ls -tp life_message_*.txt.gz | tail -n +6 | xargs -I {} rm -- {}
