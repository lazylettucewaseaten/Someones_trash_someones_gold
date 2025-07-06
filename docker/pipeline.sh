#!/bin/bash

# Paths on host - adjust as needed
SUBMISSIONS_DIR="/host/path/submissions"
TESTS_DIR="/host/path/tests"
RESULTS_DIR="/host/path/results"

# Step 1: Sort submissions outside docker
echo "Sorting submissions..."
./sort_submissions.sh "$SUBMISSIONS_DIR"

if [ $? -ne 0 ]; then
  echo "Error: sort_submissions.sh failed."
  exit 1
fi

# Step 2: Run docker container to judge
echo "Running Docker container to judge submissions..."

docker run --rm \
  -v "$SUBMISSIONS_DIR":/checker/submissions \
  -v "$TESTS_DIR":/checker/tests \
  -v "$RESULTS_DIR":/checker/results \
  your-judge-image

if [ $? -ne 0 ]; then
  echo "Error: Docker container failed."
  exit 1
fi

echo "Judging complete. Check results in $RESULTS_DIR."
