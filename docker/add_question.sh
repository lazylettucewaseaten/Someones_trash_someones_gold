#!/bin/bash


set -e

ASSIGNMENT_ID="$1"      
QUESTION_ID="$2"        
INPUT_CONTENT="$3"
OUTPUT_CONTENT="$4"

BASE_DIR="assignments/$ASSIGNMENT_ID/$QUESTION_ID"
SUBMISSIONS_DIR="$BASE_DIR/submissions"


mkdir -p "$SUBMISSIONS_DIR"

echo "$INPUT_CONTENT" > "$BASE_DIR/input.txt"
echo "$OUTPUT_CONTENT" > "$BASE_DIR/output.txt"
