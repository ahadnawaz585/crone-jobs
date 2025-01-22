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

# Keep only files created at 5-minute intervals
CURRENT_MIN=$(date "+%M")

# Check if the current minute is divisible by 5
if (( CURRENT_MIN % 5 == 0 )); then
  echo "Keeping file for minute $CURRENT_MIN"
else
  echo "Deleting intermediate file for minute $CURRENT_MIN"
  rm -f "$OUTPUT_DIR/$GZIP_NAME"
fi

# Cleanup: Keep only the last 5 files matching the naming pattern
cd "$OUTPUT_DIR" || exit
ls -tp life_message_*.txt.gz | tail -n +6 | xargs -I {} rm -- {}
