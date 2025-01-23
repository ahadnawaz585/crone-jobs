#!/bin/bash

OUTPUT_DIR="/d/development/logs"   

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S") 
FILE_NAME="life_message_${TIMESTAMP}.txt"
ZIP_NAME="life_message_${TIMESTAMP}.zip"

echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"


zip -j "$OUTPUT_DIR/$ZIP_NAME" "$OUTPUT_DIR/$FILE_NAME"

rm "$OUTPUT_DIR/$FILE_NAME"

echo "Message has been saved and compressed into $ZIP_NAME in $OUTPUT_DIR/$FILE_NAME"
