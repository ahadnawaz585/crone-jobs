#!/bin/bash

# Load environment variables from .env.backup file
ENV_FILE=""

if [ -f "$ENV_FILE" ]; then
    # Load database credentials and settings
    source "$ENV_FILE"
else
    echo "Error: Environment file not found at $ENV_FILE"
    exit 1
fi

mkdir -p "$BASE_DIR"


