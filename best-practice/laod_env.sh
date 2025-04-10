#!/bin/bash

# Load environment variables from .env.backup file
ENV_FILE="/home/deploy/codes/db_backups/.env.backup"

if [ -f "$ENV_FILE" ]; then
    # Load database credentials and settings
    source "$ENV_FILE"
else
    echo "Error: Environment file not found at $ENV_FILE"
    exit 1
fi

# Create required directories if they don't exist
mkdir -p "$BASE_DIR"

# Define DB array from environment variables
declare -A DBs
DBs["bss"]="$DB_BSS"
DBs["default"]="$DB_DEFAULT"

# Export variables for child scripts
export BASE_DIR
export DB_USER
export DB_PASSWORD
export DB_HOST
export DB_PORT
export DBs
export HOURLY_RETENTION
export DAILY_RETENTION
export WEEKLY_RETENTION
export MONTHLY_RETENTION
export YEARLY_RETENTION