#!/usr/bin/env bash
# App-Oint Health Log Rotation
# Run weekly to keep logs manageable

set -Eeuo pipefail

LOG_FILE="$HOME/Desktop/ga/health.log"
ARCHIVE_DIR="$HOME/Desktop/ga/logs"
MAX_LOGS=4  # Keep last 4 weeks

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Rotate logs if they exist and are not empty
if [[ -f "$LOG_FILE" && -s "$LOG_FILE" ]]; then
    # Create timestamped archive
    timestamp=$(date +%Y%m%d_%H%M%S)
    archive_name="health_${timestamp}.log"
    
    # Move current log to archive
    mv "$LOG_FILE" "$ARCHIVE_DIR/$archive_name"
    echo "Log rotated: $archive_name"
    
    # Clean up old logs (keep only MAX_LOGS)
    cd "$ARCHIVE_DIR"
    ls -t health_*.log | tail -n +$((MAX_LOGS + 1)) | xargs -r rm -f
    echo "Kept last $MAX_LOGS log files"
    
    # Create new empty log file
    touch "$LOG_FILE"
    echo "New log file created: $LOG_FILE"
else
    echo "No log file to rotate or file is empty"
fi

echo "Log rotation completed at $(date)"
