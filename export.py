import psycopg2

# Configuración de conexión (ajustá los valores según tu entorno Docker/PostgreSQL)
conn = psycopg2.connect(
    host="localhost",
    port="5432",
    dbname="finaldb",
    user="admin",
    password="admin123"
)

cursor = conn.cursor()

# Consulta que genera la línea formateada
query = """
SELECT
    LPAD(TO_CHAR(c.fecha, 'YYYYMMDD'), 8, '0') ||         -- Fecha
    LPAD(c.id_tipo_comprobante::text, 3, '0') ||          -- Tipo de comprobante
    LPAD(c.nro_comprobante::text, 20, '0') ||             -- Nro comprobante desde
    LPAD(c.nro_comprobante::text, 20, '0') ||             -- Nro comprobante hasta
    LPAD(cl.id_tipo_documento::text, 2, '0') ||           -- Tipo de documento del cliente
    LPAD(cl.nro_documento, 20, '0') ||                    -- Número de documento del cliente
    RPAD(cl.apellido_nombre, 30, ' ') ||                  -- Apellido y nombre con espacios
    LPAD(REPLACE(TO_CHAR(c.importe, 'FM999999999990.00'), '.', ''), 15, '0') AS linea_txt
FROM comprobantes c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
ORDER BY c.nro_comprobante;
"""

cursor.execute(query)

# Escribir resultados en archivo plano
with open("REGINFO_UAI_CBTE.txt", "w", encoding="utf-8") as file:
    for row in cursor.fetchall():
        file.write(row[0] + "\n")

print("Archivo REGINFO_UAI_CBTE.txt generado correctamente.")

# Cerrar conexión
cursor.close()
conn.close()
