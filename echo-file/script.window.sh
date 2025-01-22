#!/bin/bash

# Set variables for file paths
OUTPUT_DIR="/d/development/logs"   # Replace with your desired directory

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") 
FILE_NAME="life_message_${TIMESTAMP}.txt"
ZIP_NAME="life_message_${TIMESTAMP}.zip"

echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"

# Compress the file into a ZIP archive
zip -j "$OUTPUT_DIR/$ZIP_NAME" "$OUTPUT_DIR/$FILE_NAME"

# Remove the original text file
rm "$OUTPUT_DIR/$FILE_NAME"

# Confirm completion
echo "Message has been saved and compressed into $ZIP_NAME in $OUTPUT_DIR/$FILE_NAME"
