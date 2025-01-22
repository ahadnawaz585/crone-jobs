#!/bin/bash

# Set the output directory
OUTPUT_DIR="/home/ahad/codes/logs"   # Replace with your desired directory

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Delete files older than 5 minutes
find "$OUTPUT_DIR" -name "life_message_*.txt.gz" -mmin +5 -exec rm {} \;

# Generate a new timestamp
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILE_NAME="life_message_${TIMESTAMP}.txt"
GZIP_NAME="life_message_${TIMESTAMP}.txt.gz"

# Create a new text file
echo "This is a message about life: Stay positive, keep learning!" > "$OUTPUT_DIR/$FILE_NAME"

# Compress the new file
gzip "$OUTPUT_DIR/$FILE_NAME"

# Confirm completion
echo "Deleted files older than 5 minutes and created a new file: $GZIP_NAME in $OUTPUT_DIR"
