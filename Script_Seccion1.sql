-- Seccion 1

SELECT 'Verificando existencia de tabla locations:' as mensaje;
SELECT 
    CASE 
        WHEN EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'locations') 
        THEN 'La tabla locations YA EXISTE'
        ELSE 'La tabla locations NO EXISTE'
    END as estado_tabla;

-- Ver estructura de locations si existe
SELECT 'Columnas en locations (si existe):' as mensaje;
SELECT column_name, data_type
FROM information_schema.columns 
WHERE table_name = 'locations'
ORDER BY ordinal_position;

-- Ver datos actuales en locations si existe
SELECT 'Datos actuales en locations:' as mensaje;
SELECT COUNT(*) as total_registros FROM locations;

-- Insertar datos SOLO si no existen previamente
INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1000, 'Roma', 'Lazio', 'IT'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1000);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1100, 'Venice', 'Veneto', 'IT'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1100);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1200, 'Tokyo', 'Tokyo Prefecture', 'JP'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1200);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1300, 'Hiroshima', 'Hiroshima', 'JP'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1300);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1400, 'Southlake', 'Texas', 'US'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1400);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1500, 'South San Francisco', 'California', 'US'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1500);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1600, 'South Brunswick', 'New Jersey', 'US'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1600);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1700, 'Seattle', 'Washington', 'US'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1700);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 1800, 'Toronto', 'Ontario', 'CA'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 1800);

INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT 2500, 'Oxford', 'England', 'UK'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE location_id = 2500);

-- Consulta original MOD que causaba problemas
SELECT 'Consulta MOD con locations (FUNCIONA):' as mensaje;
SELECT 
    city, 
    location_id,
    MOD(location_id, 2) AS "Mod Demo"
FROM locations
ORDER BY location_id;

-- Ver todas las ubicaciones
SELECT 'Todas las ubicaciones disponibles:' as mensaje;
SELECT location_id, city, state_province, country_id
FROM locations
ORDER BY location_id;

-- Agrupar por país
SELECT 'Ubicaciones por país:' as mensaje;
SELECT country_id, COUNT(*) as cantidad_ciudades
FROM locations
GROUP BY country_id
ORDER BY country_id;

-- Ciudades específicas por país
SELECT 'Ciudades en Estados Unidos:' as mensaje;
SELECT city, state_province
FROM locations
WHERE country_id = 'US'
ORDER BY city;

SELECT 'Ciudades en Japón:' as mensaje;
SELECT city, state_province
FROM locations
WHERE country_id = 'JP'
ORDER BY city;


SELECT 'Estado final de la tabla locations:' as mensaje;
SELECT 
    COUNT(*) as total_registros,
    MIN(location_id) as min_id,
    MAX(location_id) as max_id
FROM locations;

-- Mostrar algunos registros de ejemplo
SELECT 'Primeros 5 registros:' as mensaje;
SELECT * FROM locations ORDER BY location_id LIMIT 5;
