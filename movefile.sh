#!/bin/bash
set -e
dir=$(dirname "$0")
GDRIVE_SYNC_DIR=$(cat $dir/gdrivesettings.txt)
echo $GDRIVE_SYNC_DIR
mv "$dir/linuxbckup/"*".tar.gz" "$GDRIVE_SYNC_DIR"
