#!/bin/bash

# Set variables for file paths
OUTPUT_DIR="/home/user"   # Replace with your desired directory
FILE_NAME="life_message.txt"
ZIP_NAME=".zip"

echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"

zip -j "$OUTPUT_DIR/$ZIP_NAME" "$OUTPUT_DIR/$FILE_NAME"

rm "$OUTPUT_DIR/$FILE_NAME"

echo "Message has been saved and compressed into $ZIP_NAME"
