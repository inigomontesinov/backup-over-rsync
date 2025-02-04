#!/bin/bash

# Ejecutar sync en el primer arranque si RUN_ON_STARTUP está activado
if [ "$RUN_ON_STARTUP" = "true" ]; then
    echo "[$(date)] Ejecutando sync inicial..."
    /sync.sh
fi

# Configurar crontab dinámicamente
echo "$CRON_SCHEDULE /sync.sh >> /var/log/backup.log 2>&1" > /etc/crontabs/root

echo "[$(date)] Tarea programada: '$CRON_SCHEDULE' para ejecutar /sync.sh"

# Iniciar cron en segundo plano
crond -f -d 8
