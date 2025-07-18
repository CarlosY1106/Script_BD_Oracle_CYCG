-- Seccion 4

-- =====================================================
-- PASO 1: VERIFICAR Y PREPARAR DATOS
-- =====================================================

-- Verificar que las tablas employees y departments tengan las columnas necesarias
SELECT 'Verificando estructura de employees:' as mensaje;
SELECT column_name FROM information_schema.columns WHERE table_name = 'employees';


-- Crear tabla locations si no existe (para que funcione la consulta MOD)
CREATE TABLE IF NOT EXISTS locations (
    location_id INTEGER PRIMARY KEY,
    city VARCHAR(100),
    state_province VARCHAR(50),
    country_id CHAR(2)
);

-- Insertar datos de ejemplo en locations
INSERT INTO locations (location_id, city, state_province, country_id) 
SELECT * FROM (VALUES 
    (1000, 'Roma', 'Lazio', 'IT'),
    (1100, 'Venice', 'Veneto', 'IT'),
    (1200, 'Tokyo', 'Tokyo Prefecture', 'JP'),
    (1300, 'Hiroshima', 'Hiroshima', 'JP'),
    (1400, 'Southlake', 'Texas', 'US'),
    (1500, 'South San Francisco', 'California', 'US'),
    (1600, 'South Brunswick', 'New Jersey', 'US'),
    (1700, 'Seattle', 'Washington', 'US'),
    (1800, 'Toronto', 'Ontario', 'CA'),
    (1900, 'Whitehorse', 'Yukon', 'CA'),
    (2000, 'Beijing', 'Beijing', 'CN'),
    (2100, 'Bombay', 'Maharashtra', 'IN'),
    (2200, 'Sydney', 'New South Wales', 'AU'),
    (2300, 'Singapore', 'Singapore', 'SG'),
    (2400, 'London', 'England', 'UK'),
    (2500, 'Oxford', 'England', 'UK'),
    (2600, 'Stretford', 'Manchester', 'UK'),
    (2700, 'Munich', 'Bavaria', 'DE'),
    (2800, 'Bern', 'BE', 'CH'),
    (2900, 'Utrecht', 'Utrecht', 'NL')
) AS v(location_id, city, state_province, country_id)
WHERE NOT EXISTS (SELECT 1 FROM locations LIMIT 1);

-- Asegurar que algunos empleados tengan datos para las pruebas
UPDATE employees SET 
    department_id = COALESCE(department_id, 60),
    hire_date = COALESCE(hire_date, '2000-01-01')
WHERE department_id IS NULL OR hire_date IS NULL;

-- =====================================================
-- DIAPOSITIVA 4.1 - FUNCIONES DE TEXTO Y NÚMEROS
-- =====================================================

-- 1. Operación matemática básica
SELECT (319.0 / 29) + 12 AS "Resultado Matemático";

-- 2. Búsqueda con LOWER (convertir a minúsculas)
SELECT last_name
FROM employees
WHERE LOWER(last_name) = 'abel';

-- 3. Búsqueda con UPPER (convertir a mayúsculas)
SELECT last_name
FROM employees 
WHERE UPPER(last_name) = 'ABEL';

-- 4. Búsqueda con INITCAP (Primera letra mayúscula)
SELECT last_name
FROM employees
WHERE INITCAP(last_name) = 'Abel';

-- 5. Función REPLACE - ejemplo con texto fijo
SELECT REPLACE('Hola mundo, hola PostgreSQL', 'hola', 'adiós') AS "Texto Reemplazado";

-- 6. Función REPLACE en una tabla
SELECT last_name, REPLACE(last_name,'a','*') AS "Apellido con asteriscos"
FROM employees;

-- 7. Concatenación y SUBSTR para crear nombres de usuario
SELECT 
    first_name,
    last_name,
    LOWER(last_name) || LOWER(SUBSTR(first_name,1,1)) AS "User Name"
FROM employees;

-- 8. Versión simplificada del nombre de usuario
SELECT 
    first_name,
    last_name,
    LOWER(last_name) || LOWER(SUBSTR(first_name,1,1)) AS "Username"
FROM employees;

-- 9. Filtrar por department_id = 10 (si existen empleados en ese departamento)
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE department_id = 10;

-- Si no hay empleados en department_id = 10, probar con otros departamentos:
SELECT 'Empleados por departamento:' as mensaje;
SELECT department_id, COUNT(*) as cantidad
FROM employees 
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

-- Consulta alternativa con departamentos que sí existen:
SELECT first_name, last_name, salary, department_id
FROM employees
WHERE department_id IN (50, 60, 80)
LIMIT 5;

-- Diapositiva 4.2

SELECT city, MOD(location_id,2) 
AS "Mod Demo"
 FROM locations;

-- Diapositiva 4.3
SELECT CURRENT_TIMESTAMP;

SELECT last_name, hire_date + 60
 FROM employees;

SELECT
    last_name,
    EXTRACT(DAY FROM (NOW() - hire_date)) / 7 AS "Semanas Trabajadas"
FROM
    employees;

SELECT
    (CURRENT_DATE + INTERVAL '1 day' * ((7 - EXTRACT(DOW FROM CURRENT_DATE) + 6) % 7)) AS "Next Saturday";

SELECT
    hire_date,
    DATE_TRUNC('month', hire_date) AS "Mes Redondeado"
FROM
    employees
WHERE
    department_id = 50;

SELECT last_name, hire_date+ 60
 FROM employees;

SELECT
    last_name,
    EXTRACT(DAY FROM (NOW() - hire_date)) / 7 AS "Semanas Trabajadas"
FROM
    employees;

SELECT
    employee_id,
    hire_date,
    -- TENURE: Equivalente a ROUND(MONTHS_BETWEEN(SYSDATE, hire_date))
    -- Calculamos los meses completos transcurridos
    FLOOR(EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) * 12 + EXTRACT(MONTH FROM AGE(CURRENT_DATE, hire_date))) AS TENURE,

    -- REVIEW: Equivalente a ADD_MONTHS(hire_date, 6)
    (hire_date + INTERVAL '6 months') AS REVIEW,

    -- NEXT_DAY(hire_date, 'FRIDAY'): Equivalente en PostgreSQL
    (hire_date + INTERVAL '1 day' * ((5 - EXTRACT(DOW FROM hire_date) + 7) % 7)) AS "NEXT_FRIDAY",

    -- LAST_DAY(hire_date): Equivalente en PostgreSQL
    (DATE_TRUNC('month', hire_date) + INTERVAL '1 month' - INTERVAL '1 day')::date AS LAST_DAY_OF_MONTH

FROM
    employees
WHERE
    -- MONTHS_BETWEEN (SYSDATE, hire_date) > 36
    -- Condición para filtrar por empleados con más de 36 meses de antigüedad
    (EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) * 12 + EXTRACT(MONTH FROM AGE(CURRENT_DATE, hire_date))) > 36;

