
-- m4_consultas_negocio.sql
-- Módulo 4
USE Ventas_Tech_db;


-- CONSULTA 1 — RESUMEN EJECUTIVO MENSUAL

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- CONSULTA 2 — RANKING DE PRODUCTOS

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC;


-- CONSULTA 3 — CLIENTES RECURRENTES

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;


-- CONSULTA 4 — MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO

WITH ventas_mensuales AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
),
promedio_mensual AS (
    SELECT
        AVG(total_facturado) AS promedio_general
    FROM ventas_mensuales
)
SELECT
    vm.mes,
    vm.total_facturado,
    pm.promedio_general,
    CASE
        WHEN vm.total_facturado > pm.promedio_general
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_mensuales AS vm
CROSS JOIN promedio_mensual AS pm
ORDER BY vm.mes;



-- BLOQUE DE CIERRE — 3 HALLAZGOS

-- Hallazgo 1: El producto 1 fue el que generó mayor facturación
-- en las ventas registradas.

-- Hallazgo 2: Los clientes 1, 2, 3, 4 y 5 son clientes recurrentes, 
-- ya que cada uno realizó más de un pedido.

-- Hallazgo 3: Marzo concentró el mayor nivel de facturación
-- entre los meses con ventas registradas.


-- FIN
