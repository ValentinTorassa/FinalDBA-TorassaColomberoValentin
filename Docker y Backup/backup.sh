#!/bin/bash

# Configuración
CONTAINER_NAME="postgres-final"
DB_NAME="finaldb"
DB_USER="admin"
BACKUP_DIR="./backups"
DATE=$(date +%Y-%m-%d)
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_$DATE.sql"

# Crear carpeta de backups si no existe
mkdir -p "$BACKUP_DIR"

# Ejecutar el backup
docker exec -t "$CONTAINER_NAME" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

echo "✅ Backup creado: $BACKUP_FILE"

# docker compose down -v
# docker compose up -d
# ./restore.sh backups/finaldb_2025-07-01.sql
