#!/bin/bash
set -e
dir=$(dirname "$0")
read -r GDRIVE_SYNC_DIR USER < $dir/gdrivesettings.txt
TIMESHIFT_DIR="/timeshift/snapshots"
SNAPSHOTS=($(ls -Art $TIMESHIFT_DIR))
BACKUP_DIR="$dir/linuxbckup"

mkdir -p $BACKUP_DIR
tar -czf "$BACKUP_DIR/latestbckp.tar.gz" -C "$TIMESHIFT_DIR/${SNAPSHOTS[-1]}" . -v
tar -czf "$BACKUP_DIR/oldestbckp.tar.gz" -C "$TIMESHIFT_DIR/${SNAPSHOTS[0]}" . -v

getent group bckupgrp >/dev/null || /usr/sbin/groupadd bckupgrp
id -nG "$USER" | grep -qw bckupgrp || /usr/sbin/usermod -aG bckupgrp "$USER"

chown -R :bckupgrp $BACKUP_DIR
chmod -R 770 $BACKUP_DIR
