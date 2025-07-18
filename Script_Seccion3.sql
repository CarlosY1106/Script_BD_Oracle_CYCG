-- diapositiva 3.1

-- =====================================================
-- PASO 1: VERIFICACIÓN INICIAL
-- =====================================================
SELECT 'VERIFICACIÓN INICIAL - Empleados existentes:' as mensaje;
SELECT employee_id, first_name, last_name FROM employees ORDER BY employee_id;

SELECT 'Columnas en employees:' as mensaje;
SELECT column_name FROM information_schema.columns WHERE table_name = 'employees';

SELECT 'Columnas en departments:' as mensaje;
SELECT column_name FROM information_schema.columns WHERE table_name = 'departments';

-- =====================================================
-- PASO 2: AGREGAR COLUMNAS NECESARIAS
-- =====================================================
ALTER TABLE employees ADD COLUMN IF NOT EXISTS department_id INTEGER;
ALTER TABLE employees ADD COLUMN IF NOT EXISTS hire_date DATE;
ALTER TABLE employees ADD COLUMN IF NOT EXISTS job_id VARCHAR(20);

ALTER TABLE departments ADD COLUMN IF NOT EXISTS manager_id INTEGER;
ALTER TABLE departments ADD COLUMN IF NOT EXISTS location_id INTEGER;
ALTER TABLE departments ADD COLUMN IF NOT EXISTS department_name VARCHAR(100);

-- =====================================================
-- PASO 3: CONFIGURAR DATOS BÁSICOS
-- =====================================================

-- Insertar departamentos (solo si no existen)
INSERT INTO departments (department_id, department_name, manager_id, location_id) 
SELECT 50, 'Shipping', 121, 1500
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 50);

INSERT INTO departments (department_id, department_name, manager_id, location_id) 
SELECT 60, 'IT', 103, 1400
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 60);

INSERT INTO departments (department_id, department_name, manager_id, location_id) 
SELECT 80, 'Sales', 145, 2500
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 80);

INSERT INTO departments (department_id, department_name, manager_id, location_id) 
SELECT 90, 'Executive', 100, 1700
WHERE NOT EXISTS (SELECT 1 FROM departments WHERE department_id = 90);

-- Actualizar empleados existentes con datos de ejemplo
UPDATE employees SET 
    department_id = 60, 
    hire_date = '1990-01-01', 
    job_id = 'IT_PROG' 
WHERE department_id IS NULL AND employee_id BETWEEN 1 AND 3;

UPDATE employees SET 
    department_id = 80, 
    hire_date = '1995-01-01', 
    job_id = 'SA_REP' 
WHERE department_id IS NULL AND employee_id BETWEEN 4 AND 6;

UPDATE employees SET 
    department_id = 50, 
    hire_date = '2000-01-01', 
    job_id = 'ST_CLERK' 
WHERE department_id IS NULL AND employee_id > 6;

-- =====================================================
-- CONSULTAS ORIGINALES CORREGIDAS
-- =====================================================

-- 1. Consulta básica con department_id y salary
SELECT last_name, department_id, salary
FROM employees
WHERE department_id > 50 AND salary > 12000;

-- 2. INSERTAR NUEVO EMPLEADO - SOLUCIÓN AL ERROR DE CLAVE DUPLICADA
-- Verificar primero si Juan López ya existe
SELECT 'Verificando si Juan López existe:' as mensaje;
SELECT COUNT(*) as ya_existe 
FROM employees 
WHERE first_name = 'Juan' AND last_name = 'López';

-- Ver próximo ID disponible
SELECT 'Próximo ID disponible:' as mensaje;
SELECT COALESCE(MAX(employee_id), 0) + 1 as proximo_id FROM employees;

-- Insertar SOLO si no existe (evita error de clave duplicada)
INSERT INTO employees (employee_id, first_name, last_name, salary, department_id, hire_date)
SELECT 
    (SELECT COALESCE(MAX(employee_id), 0) + 1 FROM employees),
    'Juan',
    'López',
    22500.00,
    60,
    CURRENT_DATE
WHERE NOT EXISTS (
    SELECT 1 FROM employees 
    WHERE first_name = 'Juan' AND last_name = 'López'
);

-- Verificar que se insertó correctamente
SELECT 'Empleado Juan López después del insert:' as mensaje;
SELECT * FROM employees WHERE first_name = 'Juan' AND last_name = 'López';

-- 3. Consulta con hire_date y job_id
SELECT last_name, hire_date, job_id
FROM employees
WHERE hire_date > '1998-01-01' AND job_id LIKE 'SA%';

-- 4. Consulta de departamentos
SELECT department_name, manager_id, location_id
FROM departments
WHERE location_id = 2500 OR manager_id = 124;

-- 5. Consulta con NOT IN
SELECT department_name, location_id
FROM departments
WHERE location_id NOT IN (1700, 1800);

-- 6. Consulta con concatenación y aumento salarial
SELECT last_name || ' ' || (salary * 1.05) AS "Employee Raise"
FROM employees
WHERE department_id IN (50, 80) 
  AND (first_name LIKE 'C%' OR last_name LIKE '%s%');

-- 7. Consulta más compleja con múltiples columnas
SELECT last_name || ' ' || (salary * 1.05) AS "Employee Raise", 
       department_id, 
       first_name
FROM employees
WHERE department_id IN (50, 80) 
  AND (first_name LIKE 'C%' OR last_name LIKE '%s%');

-- =====================================================
-- diapositiva 3.2 - CONSULTAS DE ORDENAMIENTO
-- =====================================================

-- 8. Ordenar por fecha de contratación (ascendente)
SELECT last_name, hire_date
FROM employees
ORDER BY hire_date;

-- 9. Ordenar por fecha de contratación (descendente)
SELECT last_name, hire_date
FROM employees
ORDER BY hire_date DESC;

-- 10. Usar alias en ORDER BY
SELECT last_name, hire_date AS "Date Started"
FROM employees
ORDER BY "Date Started";

-- 11. Ordenar por apellido
SELECT employee_id, first_name
FROM employees
WHERE employee_id < 105
ORDER BY last_name;

-- 12. Ordenar por múltiples columnas (ascendente)
SELECT department_id, last_name
FROM employees
WHERE department_id <= 50 
ORDER BY department_id, last_name;

-- 13. Ordenar por múltiples columnas (department_id descendente, last_name ascendente)
SELECT department_id, last_name
FROM employees
WHERE department_id <= 50 
ORDER BY department_id DESC, last_name;

-- =====================================================
-- diapositiva 3.3 - CONSULTAS DE VERIFICACIÓN FINAL
-- =====================================================

SELECT 'ESTADO FINAL - Todos los empleados:' as mensaje;
SELECT employee_id, first_name, last_name, department_id, salary, hire_date, job_id
FROM employees 
ORDER BY employee_id;

SELECT 'ESTADO FINAL - Todos los departamentos:' as mensaje;
SELECT department_id, department_name, manager_id, location_id
FROM departments 
ORDER BY department_id;

SELECT 'Estadísticas:' as mensaje;
SELECT 
    COUNT(*) as total_empleados,
    COUNT(DISTINCT department_id) as departamentos_con_empleados,
    AVG(salary) as salario_promedio
FROM employees
WHERE salary IS NOT NULL;

-- =====================================================
-- INSTRUCCIONES DE USO:
-- =====================================================
-- 1. Ejecuta todo el script de una vez
-- 2. O ejecuta sección por sección siguiendo los PASOS
-- 3. Las verificaciones te mostrarán si todo funciona correctamente
-- 4. Si Juan López ya existe, el INSERT no hará nada (no dará error)
-- 5. Todas las consultas están diseñadas para funcionar sin errores
