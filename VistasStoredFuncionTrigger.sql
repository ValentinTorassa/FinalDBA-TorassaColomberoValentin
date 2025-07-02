-- VISTA: Comprobantes con información detallada
-- Muestra todos los comprobantes con datos del cliente y tipo de comprobante
CREATE OR REPLACE VIEW vista_comprobantes_detallada AS
SELECT
c.nro_comprobante,
c.fecha,
cl.apellido_nombre AS cliente,  
cl.nro_documento,
tc.descrip_comprobante,         
c.importe
FROM comprobantes c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
JOIN tipos_comprobantes tc ON c.id_tipo_comprobante =
tc.id_tipo_comprobante;



-- VISTA: Totales facturados por cliente
-- Calcula la suma total de importes para cada cliente
CREATE OR REPLACE VIEW vista_totales_por_cliente AS
SELECT
cl.id_cliente,
cl.apellido_nombre,
SUM(c.importe) AS total_facturado  -- Suma todos los importes del cliente
FROM comprobantes c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
GROUP BY cl.id_cliente, cl.apellido_nombre
ORDER BY total_facturado DESC;     -- Ordena de mayor a menor facturación


-- =====================================================
-- PROCEDIMIENTO: Calcular total facturado en un rango de fechas
-- Muestra el total facturado entre dos fechas específicas
-- =====================================================
CREATE OR REPLACE PROCEDURE total_facturado_rango(
IN fecha_inicio DATE,
IN fecha_fin DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
RAISE NOTICE 'Total facturado del % al %: %',
fecha_inicio,
fecha_fin,
COALESCE((
SELECT SUM(importe)
FROM comprobantes
WHERE fecha BETWEEN fecha_inicio AND fecha_fin
), 0);  -- Si no hay datos, devuelve 0
END;
$$;
-- Ejecucion
CALL total_facturado_rango('2025-06-18', '2025-06-22');



-- =====================================================
-- FUNCIÓN: Calcular base imponible de un comprobante
-- Calcula la base imponible (sin IVA) de un comprobante específico
-- =====================================================
CREATE OR REPLACE FUNCTION calcular_base_imponible(nro INTEGER)
RETURNS TABLE (
nro_comprobante INTEGER,
fecha DATE,
cliente TEXT,
tipo_comprobante TEXT,
importe NUMERIC,
base_imponible NUMERIC
) AS $$
BEGIN
RETURN QUERY
SELECT
c.nro_comprobante,
c.fecha,
cl.apellido_nombre,
tc.descrip_comprobante,
c.importe,
ROUND(c.importe / 1.21, 2) AS base_imponible  -- Divide por 1.21 para quitar IVA (21%)
FROM comprobantes c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
JOIN tipos_comprobantes tc ON c.id_tipo_comprobante =
tc.id_tipo_comprobante
WHERE c.nro_comprobante = nro;
END;
$$ LANGUAGE plpgsql;
-- Ejecucion
SELECT * FROM calcular_base_imponible(1);


-- =====================================================
-- FUNCIÓN: Actualizar acumulado de compras del cliente
-- Se ejecuta automáticamente cuando se inserta un nuevo comprobante
-- =====================================================
CREATE OR REPLACE FUNCTION actualizar_acumulado()
RETURNS TRIGGER AS $$
BEGIN
UPDATE clientes
SET acumulado_compras = acumulado_compras + NEW.importe  -- Suma el nuevo importe al acumulado
WHERE id_cliente = NEW.id_cliente;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- =====================================================
-- TRIGGER: Se activa después de insertar un comprobante
-- Ejecuta automáticamente la función actualizar_acumulado()
-- =====================================================
CREATE TRIGGER trg_actualizar_acumulado
AFTER INSERT ON comprobantes
FOR EACH ROW
EXECUTE FUNCTION actualizar_acumulado()


-- =====================================================
-- CONSULTA: Generar línea de texto para exportación
-- Crea un formato de texto fijo para exportar datos
-- =====================================================
SELECT
LPAD(TO_CHAR(c.fecha, 'YYYYMMDD'), 8, '0') ||           -- Fecha en formato YYYYMMDD
LPAD(c.id_tipo_comprobante::text, 3, '0') ||            -- Tipo de comprobante (3 dígitos)
LPAD(c.nro_comprobante::text, 20, '0') ||               -- Número de comprobante (20 dígitos)
LPAD(c.nro_comprobante::text, 20, '0') ||               -- Número de comprobante duplicado
LPAD(cl.id_tipo_documento::text, 2, '0') ||             -- Tipo de documento (2 dígitos)
LPAD(cl.nro_documento, 20, '0') ||                      -- Número de documento (20 dígitos)
RPAD(cl.apellido_nombre, 30, ' ') ||                    -- Nombre del cliente (30 caracteres)
LPAD(REPLACE(TO_CHAR(c.importe, 'FM999999999990.00'), '.', ''), 15, '0') AS linea_txt  -- Importe sin decimales
FROM comprobantes c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
ORDER BY c.nro_comprobante;
