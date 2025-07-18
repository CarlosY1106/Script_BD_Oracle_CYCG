--Seccion 5

-- Drop tables if they exist (for re-running the script)
DROP TABLE IF EXISTS employees CASCADE;

-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50),
    salary NUMERIC(10,2),
    commission_pct VARCHAR(10), -- Stored as text to demonstrate conversion (replaces bonus)
    hire_date DATE,
    department_id INTEGER
);

-- Insert sample data
INSERT INTO employees (last_name, first_name, salary, commission_pct, hire_date, department_id) VALUES
('Smith', 'John', 50000.00, '0.10', '1988-03-15', 80),
('Johnson', 'Mary', 75000.00, '0.15', '1989-07-22', 80),
('Williams', 'Robert', 60000.00, '0.12', '1991-01-10', 80),
('Brown', 'Patricia', 55000.00, '0.08', '1987-11-05', 80),
('Davis', 'Michael', 80000.00, '0.20', '1992-06-18', 80),
('Miller', 'Linda', 65000.00, '0.14', '1990-09-12', 90),
('Wilson', 'William', 70000.00, '0.16', '1989-12-03', 90),
('Moore', 'Elizabeth', 45000.00, '0.06', '1993-04-25', 90);

-- Verify the data
SELECT 'Sample data inserted successfully' AS status;
SELECT COUNT(*) AS total_employees FROM employees;

-- Display sample data
SELECT 
    employee_id,
    last_name,
    first_name,
    salary,
    commission_pct,
    hire_date,
    department_id
FROM employees
ORDER BY employee_id;

-- ==============================================
-- SECCIÓN 5: FUNCIONES DE CONVERSIÓN ORACLE → POSTGRESQL
-- ==============================================

SELECT 'TO_CHAR para fechas' AS ejemplo;
SELECT 
    last_name,
    hire_date,
    TO_CHAR(hire_date, 'DD-Mon-YY') AS fecha_formato_corto,
    TO_CHAR(hire_date, 'Month DD, YYYY') AS fecha_formato_largo,
    TO_CHAR(hire_date, 'Day, DD-MM-YYYY') AS fecha_con_dia
FROM employees
ORDER BY hire_date;

SELECT 'TO_CHAR para números' AS ejemplo;
SELECT 
    last_name,
    salary,
    TO_CHAR(salary, 'FM$999,999') AS salario_formateado,
    TO_CHAR(salary, 'FM$999,999.00') AS salario_con_centavos
FROM employees
ORDER BY salary DESC;

SELECT 'TO_NUMBER equivalentes' AS ejemplo;
SELECT 
    last_name,
    commission_pct AS comision_texto,
    CAST(commission_pct AS DECIMAL(3,2)) AS comision_decimal,
    commission_pct::DECIMAL(3,2) AS comision_con_operador,
    TO_CHAR(commission_pct::DECIMAL(3,2) * 100, 'FM999.99') || '%' AS comision_porcentaje
FROM employees
WHERE department_id = 80;

SELECT 'TO_DATE ejemplos' AS ejemplo;
SELECT 
    TO_DATE('November 3, 2001', 'Month DD, YYYY') AS fecha_convertida1,
    TO_DATE('27-Oct-95', 'DD-Mon-YY') AS fecha_convertida2,
    TO_DATE('10-May-1989', 'DD-Mon-YYYY') AS fecha_convertida3,
    '1990-01-01'::DATE AS fecha_con_cast;

-- 5. Ejemplos combinados con datos de empleados
SELECT 'Ejemplos combinados' AS ejemplo;
SELECT 
    last_name,
    TO_CHAR(hire_date, 'DD-Mon-YY') AS fecha_contratacion
FROM employees
WHERE hire_date < TO_DATE('01-Jan-90', 'DD-Mon-YY')
ORDER BY hire_date;

-- 6. Funciones adicionales de PostgreSQL
SELECT 'Funciones adicionales PostgreSQL' AS ejemplo;
SELECT 
    last_name,
    hire_date,
    EXTRACT(YEAR FROM hire_date) AS año_contratacion,
    EXTRACT(MONTH FROM hire_date) AS mes_contratacion,
    EXTRACT(DAY FROM hire_date) AS dia_contratacion,
    AGE(CURRENT_DATE, hire_date) AS tiempo_empleado
FROM employees
ORDER BY hire_date;

-- 7. Formateo moderno de PostgreSQL
SELECT 'Formateo moderno PostgreSQL' AS ejemplo;
SELECT 
    last_name,
    hire_date::TEXT AS fecha_como_texto,
    hire_date::VARCHAR(10) AS fecha_como_varchar,
    salary * commission_pct::DECIMAL(3,2) AS comision_calculada
FROM employees
WHERE commission_pct::DECIMAL(3,2) > 0.10;

-- 8. Casos de uso prácticos
SELECT 'Casos prácticos' AS ejemplo;
SELECT 
    last_name,
    TO_CHAR(salary, 'FM$999,999') AS salario_formateado,
    CASE 
        WHEN salary >= 70000 THEN 'Alto'
        WHEN salary >= 55000 THEN 'Medio'
        ELSE 'Bajo'
    END AS categoria_salario,
    TO_CHAR(hire_date, 'Mon YYYY') AS mes_año_contratacion
FROM employees
ORDER BY salary DESC;
