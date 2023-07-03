#!/bin/bash
set -e
dir=$(dirname "$0")
read -r GDRIVE_SYNC_DIR USER < $dir/gdrivesettings.txt
echo $GDRIVE_SYNC_DIR
mv "$dir/linuxbckup/"*".tar.gz" "$GDRIVE_SYNC_DIR"
