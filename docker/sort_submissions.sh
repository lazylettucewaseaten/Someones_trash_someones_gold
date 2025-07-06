#!/bin/bash

# Submissions are in a submissions_raw/ folder.
set -e

RAW_DIR="submissions_raw"
BASE_DIR="assignments"

for file in "$RAW_DIR"/*_*_*.*; do
    filename=$(basename "$file")
    
    # Parse ROLLNO, ASSIGNMENT_ID, and QUESTION_ID
    rollno=$(echo "$filename" | cut -d'_' -f1)
    assignment=$(echo "$filename" | cut -d'_' -f2)
    question=$(echo "$filename" | cut -d'_' -f3 | cut -d'.' -f1)
    
    # Build destination directory
    dest_dir="$BASE_DIR/$assignment/$question/submissions"
    
    # Create if not exists
    mkdir -p "$dest_dir"
    
    # Copy/move file
    cp "$file" "$dest_dir/$filename"
done

echo "✅ Submissions sorted into question folders."
