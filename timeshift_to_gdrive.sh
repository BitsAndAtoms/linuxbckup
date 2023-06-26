#!/bin/bash
set -e
dir=$(dirname "$0")
read -r GDRIVE_SYNC_DIR USER < $dir/gdrivesettings.txt
TIMESHIFT_DIR="/timeshift/snapshots"
SNAPSHOTS=($(ls -Art $TIMESHIFT_DIR))
BACKUP_DIR="$dir/linuxbckup"
# Get the latest snapshot
LATEST_SNAPSHOT=$(ls -Art $TIMESHIFT_DIR | tail -n 1)
# Get the oldest snapshot
OLDEST_SNAPSHOT=$(ls -Art $TIMESHIFT_DIR | head -n 1)
mkdir -p $BACKUP_DIR
tar -czf "$BACKUP_DIR/latestbckp.tar.gz" -C "$TIMESHIFT_DIR/$LATEST_SNAPSHOT" . -v
tar -czf "$BACKUP_DIR/oldestbckp.tar.gz" -C "$TIMESHIFT_DIR/$OLDEST_SNAPSHOT" . -v

getent group bckupgrp >/dev/null || /usr/sbin/groupadd bckupgrp
id -nG "$USER" | grep -qw bckupgrp || /usr/sbin/usermod -aG bckupgrp "$USER"

chown -R :bckupgrp $BACKUP_DIR
chmod -R 770 $BACKUP_DIR
