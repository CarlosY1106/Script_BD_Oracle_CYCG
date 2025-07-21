-- ===============================================================
-- CONVERSIÓN DE ORACLE A POSTGRESQL: GROUP BY Y FUNCIONES DE AGREGACIÓN
-- ===============================================================

-- ===============================================================
-- 1. CONSULTAS BÁSICAS CON GROUP BY
-- ===============================================================

-- Promedio de salarios por departamento
SELECT department_id, AVG(salary) AS salario_promedio
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Salario máximo por departamento (sin mostrar department_id)
SELECT MAX(salary) AS salario_maximo
FROM employees
GROUP BY department_id
ORDER BY MAX(salary) DESC;

-- Salario máximo por departamento (mostrando department_id)
SELECT department_id, MAX(salary) AS salario_maximo
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- ===============================================================
-- 2. CONSULTAS CON TABLAS RELACIONADAS A PAÍSES (SIMULADAS)
-- ===============================================================

-- Como las tablas wf_countries y wf_spoken_languages no existen,
-- usamos consultas equivalentes con nuestras tablas existentes

-- Contar empleados por ubicación (equivalente a countries por region)
SELECT l.country_id, COUNT(e.employee_id) AS total_empleados
FROM locations l
LEFT JOIN departments d ON l.location_id = d.location_id
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY l.country_id
ORDER BY l.country_id;

-- Contar departamentos por país
SELECT l.country_id, COUNT(d.department_id) AS total_departamentos
FROM locations l
LEFT JOIN departments d ON l.location_id = d.location_id
GROUP BY l.country_id
ORDER BY l.country_id;

-- Promedio de salarios por país
SELECT l.country_id, ROUND(AVG(e.salary)) AS salario_promedio_pais
FROM locations l
JOIN departments d ON l.location_id = d.location_id
JOIN employees e ON d.department_id = e.department_id
GROUP BY l.country_id
ORDER BY l.country_id;

-- Contar diferentes tipos de trabajo por ubicación
SELECT l.city, COUNT(DISTINCT e.job_id) AS "Tipos de trabajo"
FROM locations l
JOIN departments d ON l.location_id = d.location_id
JOIN employees e ON d.department_id = e.department_id
GROUP BY l.city
ORDER BY l.city;

-- ===============================================================
-- 3. CONSULTAS CON MÚLTIPLES COLUMNAS EN GROUP BY
-- ===============================================================

-- Contar empleados por departamento y trabajo
SELECT department_id, job_id, COUNT(*) AS total_empleados
FROM employees
WHERE department_id > 5  -- Adaptado: cambiado de 40 a 5 para tener datos
GROUP BY department_id, job_id
ORDER BY department_id, job_id;

-- ===============================================================
-- 4. CONSULTAS CON HAVING (FILTROS DESPUÉS DE GROUP BY)
-- ===============================================================

-- Departamentos con más de 1 empleado
SELECT department_id, COUNT(*) AS total_empleados
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) > 1
ORDER BY department_id;

-- Departamentos con salario promedio mayor a 8000
SELECT department_id, AVG(salary) AS salario_promedio
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > 8000
ORDER BY salario_promedio DESC;

-- ===============================================================
-- 5. COMBINACIONES AVANZADAS CON WHERE, GROUP BY, HAVING, ORDER BY
-- ===============================================================

-- Análisis completo por departamento
SELECT 
    department_id,
    COUNT(*) AS total_empleados,
    AVG(salary) AS salario_promedio,
    MAX(salary) AS salario_maximo,
    MIN(salary) AS salario_minimo,
    SUM(salary) AS masa_salarial
FROM employees
WHERE department_id IS NOT NULL
  AND salary IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) >= 2
ORDER BY salario_promedio DESC;

-- Análisis por tipo de trabajo
SELECT 
    job_id,
    COUNT(*) AS cantidad_empleados,
    ROUND(AVG(salary), 2) AS salario_promedio,
    MAX(salary) AS salario_maximo
FROM employees
WHERE job_id IS NOT NULL
  AND salary > 5000
GROUP BY job_id
HAVING COUNT(*) > 1
ORDER BY salario_promedio DESC;

-- ===============================================================
-- 6. CONSULTAS CON SUBCONSULTAS Y GROUP BY
-- ===============================================================

-- Departamentos con salario promedio mayor al promedio general
SELECT 
    department_id,
    AVG(salary) AS salario_promedio_depto
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees)
ORDER BY salario_promedio_depto DESC;

-- ===============================================================
-- 7. ANÁLISIS ESTADÍSTICO AVANZADO
-- ===============================================================

-- Distribución de empleados por rango salarial
SELECT 
    CASE 
        WHEN salary < 5000 THEN 'Bajo (< 5000)'
        WHEN salary BETWEEN 5000 AND 10000 THEN 'Medio (5000-10000)'
        WHEN salary > 10000 THEN 'Alto (> 10000)'
        ELSE 'Sin datos'
    END AS rango_salarial,
    COUNT(*) AS cantidad_empleados,
    AVG(salary) AS promedio_en_rango
FROM employees
WHERE salary IS NOT NULL
GROUP BY 
    CASE 
        WHEN salary < 5000 THEN 'Bajo (< 5000)'
        WHEN salary BETWEEN 5000 AND 10000 THEN 'Medio (5000-10000)'
        WHEN salary > 10000 THEN 'Alto (> 10000)'
        ELSE 'Sin datos'
    END
ORDER BY promedio_en_rango;

-- ===============================================================
-- 8. RESUMEN GENERAL DE DATOS
-- ===============================================================

-- Resumen completo de la empresa
SELECT 
    COUNT(*) AS total_empleados,
    COUNT(DISTINCT department_id) AS departamentos_activos,
    COUNT(DISTINCT job_id) AS tipos_trabajo,
    ROUND(AVG(salary), 2) AS salario_promedio_empresa,
    MAX(salary) AS salario_maximo_empresa,
    MIN(salary) AS salario_minimo_empresa
FROM employees;

-- Distribución por departamento con porcentajes
SELECT 
    department_id,
    COUNT(*) AS empleados,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2) AS porcentaje
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
ORDER BY empleados DESC;