#!/bin/bash

# Set variables for file paths
OUTPUT_DIR="/d/development/logs"  # Replace with your desired directory

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Generate timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_NAME="life_message_${TIMESTAMP}.txt"
ZIP_NAME="life_message_${TIMESTAMP}.zip"

# Create the text file
echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"

# Compress the file into a ZIP archive
zip -j "$OUTPUT_DIR/$ZIP_NAME" "$OUTPUT_DIR/$FILE_NAME"

# Remove the original text file
rm "$OUTPUT_DIR/$FILE_NAME"

# Confirm completion
echo "Message has been saved and compressed into $ZIP_NAME in $OUTPUT_DIR"

# Keep only files created at 5-minute intervals
CURRENT_MIN=$(date "+%M")

if (( CURRENT_MIN % 5 == 0 )); then
  echo "Keeping file for minute $CURRENT_MIN"
else
  echo "Deleting intermediate file for minute $CURRENT_MIN"
  rm -f "$OUTPUT_DIR/$ZIP_NAME"
fi

# Cleanup: Keep only the last 5 ZIP files matching the naming pattern
cd "$OUTPUT_DIR" || exit
ls -tp life_message_*.zip | tail -n +6 | xargs -I {} rm -- {}
