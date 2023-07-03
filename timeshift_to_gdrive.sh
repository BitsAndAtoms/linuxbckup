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
. /root/mysecretsforbackupjobs
TOKEN_RESPONSE=$(curl --request POST --data "client_id=${CLIENT_ID_BACKUP}&client_secret=${CLIENT_SECRET_BACKUP}&refresh_token=${REFRESH_TOKEN_BACKUP}&grant_type=refresh_token" https://accounts.google.com/o/oauth2/token)
ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r .access_token)
# Replace FILE_ID with the ID of the file you want to update
curl --request PUT \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/gzip" \
  --data-binary @"$BACKUP_DIR/latestbckp.tar.gz" \
  "https://www.googleapis.com/upload/drive/v3/files/{fileidhere}?uploadType=media"
# tar -czf "$BACKUP_DIR/oldestbckp.tar.gz" -C "$TIMESHIFT_DIR/$OLDEST_SNAPSHOT" . -v
