-- Seccion 7
-- ===============================================================
-- 1. EJEMPLO CON EMPLOYEES Y JOBS
-- ===============================================================

SELECT employees.last_name, employees.job_id, jobs.job_title
FROM employees 
INNER JOIN jobs ON employees.job_id = jobs.job_id;

-- ===============================================================
-- 2. EJEMPLO CON EMPLOYEES Y DEPARTMENTS
-- ===============================================================

SELECT employees.last_name, departments.department_name
FROM employees 
INNER JOIN departments ON employees.department_id = departments.department_id;

-- ===============================================================
-- 3. EJEMPLO CON ALIASES Y FILTRO ADICIONAL
-- ===============================================================

SELECT last_name, e.job_id, job_title
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
WHERE e.department_id = 80;

-- ===============================================================
-- 4. EJEMPLO CON MÚLTIPLES TABLAS (3 JOINS)
-- ===============================================================

SELECT last_name, city
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id;

-- ===============================================================
-- 5. EJEMPLO CON BETWEEN (Funciona igual)
-- ===============================================================

SELECT last_name, salary, grade_level, lowest_sal, highest_sal
FROM employees
INNER JOIN job_grades ON (salary BETWEEN lowest_sal AND highest_sal);

-- ===============================================================
-- 6. OUTER JOINS: CONVERSIONES DE OPERADOR (+) ORACLE
-- ===============================================================

-- RIGHT OUTER JOIN (incluir todos los departments)
SELECT e.last_name, d.department_id, d.department_name
FROM employees e
RIGHT OUTER JOIN departments d ON e.department_id = d.department_id;

-- LEFT OUTER JOIN (incluir todos los employees)
SELECT e.last_name, d.department_id, d.department_name
FROM employees e
LEFT OUTER JOIN departments d ON e.department_id = d.department_id;

-- FULL OUTER JOIN (incluir todos los registros de ambas tablas)
SELECT e.last_name, d.department_id, d.department_name
FROM employees e
FULL OUTER JOIN departments d ON e.department_id = d.department_id;

-- ===============================================================
-- 7. EJEMPLOS PRÁCTICOS CON DATOS REALES
-- ===============================================================

-- Obtener todos los empleados con sus trabajos (INNER JOIN)
SELECT e.last_name, e.first_name, j.job_title
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
ORDER BY e.last_name;

-- Obtener todos los departamentos y sus empleados (si los tienen)
SELECT d.department_name, e.last_name
FROM departments d
LEFT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_name;

-- Obtener todos los empleados y sus departamentos (si los tienen)
SELECT e.last_name, d.department_name
FROM employees e
LEFT OUTER JOIN departments d ON e.department_id = d.department_id
ORDER BY e.last_name;

-- Obtener información completa: empleados, trabajos, departamentos y ubicaciones
SELECT 
    e.first_name,
    e.last_name,
    j.job_title,
    d.department_name,
    l.city
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
ORDER BY e.last_name;

-- ===============================================================
-- 8. COMPARACIONES DE JOINS ADICIONALES
-- ===============================================================

-- Empleados con salarios altos y sus departamentos
SELECT e.last_name, e.salary, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 10000
ORDER BY e.salary DESC;

-- Empleados del departamento de IT con sus trabajos
SELECT e.last_name, e.first_name, j.job_title, d.department_name
FROM employees e
INNER JOIN jobs j ON e.job_id = j.job_id
INNER JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT'
ORDER BY e.last_name;

-- Estadísticas por departamento con ubicación
SELECT 
    d.department_name,
    l.city,
    COUNT(e.employee_id) AS total_empleados,
    AVG(e.salary) AS salario_promedio
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
INNER JOIN locations l ON d.location_id = l.location_id
GROUP BY d.department_name, l.city
ORDER BY total_empleados DESC;

-- ===============================================================
-- 9. SELF JOINS (EMPLEADOS Y SUS MANAGERS)
-- ===============================================================

-- Empleados y sus managers
SELECT 
    worker.last_name AS empleado,
    manager.last_name AS manager
FROM employees worker
LEFT JOIN employees manager ON worker.manager_id = manager.employee_id
ORDER BY worker.last_name;

-- Jerarquía con nombres completos
SELECT 
    worker.first_name || ' ' || worker.last_name AS empleado_completo,
    COALESCE(manager.first_name || ' ' || manager.last_name, 'Sin Manager') AS manager_completo
FROM employees worker
LEFT JOIN employees manager ON worker.manager_id = manager.employee_id
ORDER BY worker.last_name;

-- ===============================================================
-- 10. CASOS ESPECIALES DE JOINS
-- ===============================================================

-- Empleados sin departamento asignado
SELECT e.last_name, e.first_name, 'Sin Departamento' AS status
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- Departamentos sin empleados
SELECT d.department_name, 'Sin Empleados' AS status
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
WHERE e.employee_id IS NULL;

-- Resumen de empleados por ubicación
SELECT 
    l.city,
    l.country_id,
    COUNT(e.employee_id) AS total_empleados
FROM locations l
LEFT JOIN departments d ON l.location_id = d.location_id
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY l.city, l.country_id
ORDER BY total_empleados DESC;