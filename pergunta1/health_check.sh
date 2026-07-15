#!/bin/bash

LOGFILE="$(dirname "$0")/logs/health_check.log"
URL="http://localhost/status.php"
EXIT_CODE=0

mkdir -p "$(dirname "$LOGFILE")"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

check_service() {
    local service="$1"

    if systemctl is-active --quiet "$service"; then
        log "OK - Serviço $service ativo"
    else
        log "ERRO - Serviço $service inativo"
        EXIT_CODE=1
    fi
}

check_service nginx
check_service php8.1-fpm

if curl --silent --fail --max-time 5 "$URL" | grep -q "PHP-FPM OK"; then
    log "OK - Aplicação respondeu em $URL"
else
    log "ERRO - Aplicação não respondeu corretamente em $URL"
    EXIT_CODE=1
fi

exit "$EXIT_CODE"
