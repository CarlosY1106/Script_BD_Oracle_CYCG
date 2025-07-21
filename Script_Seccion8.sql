-- Seccion 8

-- ===============================================================
-- CONVERSIÓN DE ORACLE A POSTGRESQL: FUNCIONES DE GRUPO Y AGREGACIÓN
-- ===============================================================

-- ===============================================================
-- 1. CONSULTA CON ERROR CORREGIDA
-- ===============================================================

-- POSTGRESQL (CORRECTO - Usando subquery):
SELECT last_name, first_name, salary
FROM employees
WHERE salary = (SELECT MIN(salary) FROM employees);

-- ALTERNATIVA con LIMIT (más eficiente en algunos casos):
SELECT last_name, first_name, salary
FROM employees
ORDER BY salary ASC
LIMIT 1;

-- ===============================================================
-- 2. FUNCIÓN AVG (Promedio) - Funciona igual
-- ===============================================================

-- Promedio de comisiones (excluyendo NULLs automáticamente)
SELECT AVG(commission_pct) AS promedio_comision
FROM employees;

-- ===============================================================
-- 3. FUNCIONES MAX, MIN - Funcionan igual
-- ===============================================================

SELECT 
    MAX(salary) AS salario_maximo,
    MIN(salary) AS salario_minimo,
    MIN(employee_id) AS primer_empleado_id
FROM employees
WHERE department_id = 60;

-- ===============================================================
-- 4. FUNCIÓN COUNT - Funciona igual
-- ===============================================================

-- Contar job_ids (excluyendo NULLs)
SELECT COUNT(job_id) AS total_jobs_asignados
FROM employees;

-- Contar todos los registros (incluyendo NULLs)
SELECT COUNT(*) AS total_empleados
FROM employees;

-- ===============================================================
-- 5. FILTRO POR FECHA CORREGIDO
-- ===============================================================

SELECT COUNT(*) AS empleados_antes_1996
FROM employees
WHERE hire_date < '1996-01-01'::DATE;

-- Alternativa con TO_DATE:
SELECT COUNT(*) AS empleados_antes_1996_alt
FROM employees
WHERE hire_date < TO_DATE('01-Jan-1996', 'DD-Mon-YYYY');

-- ===============================================================
-- 6. SELECT SIMPLE Y DISTINCT - Funcionan igual
-- ===============================================================

-- Todos los job_ids (con duplicados)
SELECT job_id
FROM employees
ORDER BY job_id;

-- Job_ids únicos (sin duplicados)
SELECT DISTINCT job_id
FROM employees
ORDER BY job_id;

-- ===============================================================
-- 7. SUM con DISTINCT - Funciona igual
-- ===============================================================

-- Suma de salarios únicos en el departamento 90
SELECT SUM(DISTINCT salary) AS suma_salarios_unicos
FROM employees
WHERE department_id = 90;

-- Comparación: suma normal vs suma con DISTINCT
SELECT 
    SUM(salary) AS suma_total,
    SUM(DISTINCT salary) AS suma_salarios_unicos,
    COUNT(salary) AS total_empleados,
    COUNT(DISTINCT salary) AS salarios_diferentes
FROM employees
WHERE department_id = 90;

-- ===============================================================
-- 8. NVL (Oracle) → COALESCE (PostgreSQL)
-- ===============================================================

-- Promedio excluyendo NULLs (comportamiento por defecto)
SELECT AVG(commission_pct) AS promedio_sin_nulls
FROM employees;

-- Promedio incluyendo NULLs como 0
SELECT AVG(COALESCE(commission_pct, 0)) AS promedio_con_nulls_como_cero
FROM employees;

-- Comparación de ambos métodos:
SELECT 
    AVG(commission_pct) AS promedio_sin_nulls,
    AVG(COALESCE(commission_pct, 0)) AS promedio_con_nulls_como_cero,
    COUNT(commission_pct) AS empleados_con_comision,
    COUNT(*) AS total_empleados
FROM employees;

-- ===============================================================
-- 9. EJEMPLOS CON GROUP BY
-- ===============================================================

-- Estadísticas por departamento
SELECT 
    department_id,
    COUNT(*) AS total_empleados,
    AVG(salary) AS salario_promedio,
    MAX(salary) AS salario_maximo,
    MIN(salary) AS salario_minimo,
    SUM(salary) AS masa_salarial
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

-- Estadísticas por tipo de trabajo
SELECT 
    job_id,
    COUNT(*) AS cantidad_empleados,
    AVG(salary) AS salario_promedio,
    ROUND(AVG(salary), 2) AS salario_promedio_redondeado
FROM employees
WHERE job_id IS NOT NULL
GROUP BY job_id
ORDER BY salario_promedio DESC;

-- ===============================================================
-- 10. FUNCIONES AVANZADAS (PostgreSQL)
-- ===============================================================

-- Desviación estándar y varianza
SELECT 
    department_id,
    COUNT(*) AS empleados,
    AVG(salary) AS promedio,
    STDDEV(salary) AS desviacion_estandar,
    VARIANCE(salary) AS varianza
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

-- Percentiles
SELECT 
    department_id,
    COUNT(*) AS empleados,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY salary) AS mediana,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) AS q1,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) AS q3
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY department_id;

-- ===============================================================
-- 11. FUNCIONES DE VENTANA
-- ===============================================================

-- Ranking de salarios
SELECT 
    employee_id,
    last_name,
    salary,
    department_id,
    RANK() OVER (ORDER BY salary DESC) AS ranking_general,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS ranking_departamento
FROM employees
ORDER BY department_id, salary DESC;

-- ===============================================================
-- 12. VERIFICACIÓN DE DATOS
-- ===============================================================

-- Resumen general de la tabla
SELECT 
    'Total empleados' AS metrica,
    COUNT(*)::TEXT AS valor
FROM employees

UNION ALL

SELECT 
    'Empleados con comisión',
    COUNT(commission_pct)::TEXT
FROM employees

UNION ALL

SELECT 
    'Departamentos únicos',
    COUNT(DISTINCT department_id)::TEXT
FROM employees

UNION ALL

SELECT 
    'Trabajos únicos',
    COUNT(DISTINCT job_id)::TEXT
FROM employees

UNION ALL

SELECT 
    'Salario promedio',
    ROUND(AVG(salary), 2)::TEXT
FROM employees;