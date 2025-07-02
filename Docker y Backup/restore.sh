#!/bin/bash

# Configuración
CONTAINER_NAME="postgres-final"
DB_NAME="finaldb"
DB_USER="admin"
BACKUP_FILE="$1"

if [ -z "$BACKUP_FILE" ]; then
  echo "❌ Debes indicar el archivo de backup como parámetro"
  echo "Uso: ./restore.sh backups/finaldb_2025-07-01.sql"
  exit 1
fi

# Restaurar
cat "$BACKUP_FILE" | docker exec -i "$CONTAINER_NAME" psql -U "$DB_USER" -d "$DB_NAME"

echo "✅ Restauración completada desde: $BACKUP_FILE"
