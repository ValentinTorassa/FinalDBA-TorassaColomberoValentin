# Proyecto Final Valentìn Torassa Colombero - Base de Datos Avanzadas

Este repositorio contiene los archivos utilizados para el trabajo final de la materia de Base de Datos Avanzadas de Valentìn Torassa Colombero. Incluye scripts SQL con la estructura y datos de ejemplo, una configuración de Docker para levantar un contenedor de PostgreSQL y un pequeño script en Python que exporta información a un archivo de texto.

## Estructura

- `TablasDatos.sql`: crea las tablas `tipos_documentos`, `tipos_comprobantes`, `clientes` y `comprobantes`, además de insertar datos de prueba.
- `Vistas_SP_FN_TR.sql`: espacio reservado para vistas, funciones y triggers.
- `Docker y Backup/`
  - `docker-compose.yml`: despliega un contenedor con PostgreSQL 15 y carga los scripts de inicialización.
  - `backup_pgsql_Valen.sh`: script para realizar un respaldo de la base (actualmente sin contenido).
- `Python y Output/`
  - `export.py`: exporta comprobantes formateados en el archivo `REGINFO_UAI_CBTE.txt`.
  - `REGINFO_UAI_CBTE.txt`: ejemplo de salida generada por el script.
  - `venv/`: entorno virtual con las dependencias usadas.
- `Documentacion/`: documentación del proyecto en formato PDF y DOCX.

