#!/usr/bin/env bash
# scan-new-projects.sh

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting project auto-discovery..."

# Check if bd CLI is available
if ! command -v bd &> /dev/null
then
    echo "Error: 'bd' command not found. Please ensure Beads CLI is installed and in your PATH."
    exit 1
fi

LAST_COMMIT=$(bd meta get last_commit || echo "Initial scan: no previous commit found.")
echo "Last scanned commit: $LAST_COMMIT"

NEW_FILES=$(git diff --name-only "$LAST_COMMIT" HEAD)
echo "Found new or modified files/directories since last scan: $NEW_FILES"

for file in $NEW_FILES; do
  if [[ -d $file && $file == projects/* ]]; then
    PROJECT_NAME="${file#projects/}"
    echo "Discovered new project directory: $PROJECT_NAME. Creating issue..."
    bd issue create "Import new project $PROJECT_NAME" --tag auto-import || echo "Warning: Could not create issue for $PROJECT_NAME. It might already exist or 'bd' encountered an error."
  fi
done

bd meta set last_commit HEAD
echo "Updated last scanned commit to HEAD."
echo "Project auto-discovery complete."