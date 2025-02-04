#!/bin/bash

# Variables de entorno
REMOTE_USER=${REMOTE_USER:-"user"}
REMOTE_HOST=${REMOTE_HOST:-"192.168.1.1"}
REMOTE_PATH=${REMOTE_PATH:-"/remote/folder"}
LOCAL_PATH=${LOCAL_PATH:-"/local/folder"}
FINAL_DESTINATION_PATH=${FINAL_DESTINATION_PATH:-"/local/folder"}
SERVICE=${SERVICE:-"SERVICE"}
BACKUP_ROTATION=${BACKUP_ROTATION:-7}  # How many backups to keep
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="${SERVICE}_${DATE}"
ENABLE_GZIP=${ENABLE_GZIP:-"true"}

# Ejecutar rsync con eliminación de archivos locales no presentes en el remoto
rsync -avz --delete -e "ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/" "$LOCAL_PATH"

echo "[$(date)] Compressing backup..."

cd "$FINAL_DESTINATION_PATH"

echo "[$(date)] Create .tar..."
tar -cf ${BACKUP_NAME}.tar "$LOCAL_PATH" > /dev/null 2>&1

if [ "$ENABLE_GZIP" = "true" ]; then
    EXTENSION="gz"
    echo "[$(date)] Compress with gzip..."
    gzip ${BACKUP_NAME}.tar
    echo "[$(date)] Backup saved in: "$FINAL_DESTINATION_PATH"/${BACKUP_NAME}.tar.gz"
else
    EXTENSION="tar"
    echo "[$(date)] Backup saved in: "$FINAL_DESTINATION_PATH"/${BACKUP_NAME}.tar"
fi

# Backup rotation: Keep only the last N backups
echo "[$(date)] Applying backup rotation (keeping the last $BACKUP_ROTATION)..."
ls -tp "$FINAL_DESTINATION_PATH"/*."$EXTENSION" | grep -v '/$' | tail -n +$((BACKUP_ROTATION + 1)) | xargs -I {} rm -- "$FINAL_DESTINATION_PATH/{}"

echo "[$(date)] Backup rotation completed."

echo "Sync completed at $(date)"