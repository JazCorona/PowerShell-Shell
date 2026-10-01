#!/bin/bash
# ============================================================
# check_port.sh - Revisa si un puerto TCP está abierto o cerrado
# Uso: ./check_port.sh <puerto> [host]
# Ejemplos:
#   ./check_port.sh 80
#   ./check_port.sh 80 127.0.0.1
#   ./check_port.sh 443 google.com
# ============================================================

# 1. Validar que se recibió al menos 1 argumento
if [ $# -lt 1 ]; then
    echo "Uso: $0 <puerto> [host]"
    echo "Ejemplo: $0 80 127.0.0.1"
    exit 2
fi

PORT="$1"
HOST="${2:-127.0.0.1}"
TIMEOUT_SEC=2

# 2. Validar que el puerto sea un número entre 1 y 65535
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || [ "$PORT" -lt 1 ] || [ "$PORT" -gt 65535 ]; then
    echo "Error: '$PORT' no es un puerto válido. Debe ser un número entre 1 y 65535."
    exit 2
fi

# 3. Intentar conexión TCP al host:puerto con timeout
# /dev/tcp es una característica especial de bash, no necesita nc ni nmap.
if timeout "$TIMEOUT_SEC" bash -c "cat < /dev/null > /dev/tcp/$HOST/$PORT" 2>/dev/null; then
    echo "Puerto $PORT en $HOST está ABIERTO"
    exit 0
else
    echo "Puerto $PORT en $HOST está CERRADO"
    exit 1
fi
