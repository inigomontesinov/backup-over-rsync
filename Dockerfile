# Use a lightweight base image
FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache openssh-client curl bash coreutils findutils rsync

# Environment variables (customizable in docker run)
ENV REMOTE_USER="192.168.88.1"
ENV REMOTE_HOST="admin"
ENV REMOTE_PATH="/tmp"
ENV LOCAL_PATH="/tmp"
ENV FINAL_DESTINATION_PATH="/tmp"
ENV SERVICE="SERVICE"
# Default execution at midnight
ENV CRON_SCHEDULE="0 0 * * *"
# How many backups to keep before deleting
ENV BACKUP_ROTATION=7
# Run backup on container startup
ENV RUN_ON_STARTUP=true
ENV ENABLE_GZIP=true

WORKDIR /

COPY sync.sh start.sh ./
RUN chmod +x sync.sh start.sh \
    && ln -sf /dev/stdout /var/log/backup.log

CMD ["./start.sh"]