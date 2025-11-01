#!/usr/bin/env bash
# scan-new-projects.sh

LAST_COMMIT=$(bd meta get last_commit || echo "")
NEW_FILES=$(git diff --name-only $LAST_COMMIT HEAD)

for file in $NEW_FILES; do
  if [[ -d $file && $file == projects/* ]]; then
    bd issue create "Import new project ${file#projects/}" --tag auto-import
  fi
done

bd meta set last_commit HEAD

#!/usr/bin/env bash
# scan-new-projects.sh

LAST_COMMIT=$(bd meta get last_commit || echo "")
NEW_FILES=$(git diff --name-only $LAST_COMMIT HEAD)

for file in $NEW_FILES; do
  if [[ -d $file && $file =~ projects/.+ ]]; then
    bd issue create "Import new project ${file#projects/}" --tag auto-import
  fi
done

bd meta set last_commit HEAD