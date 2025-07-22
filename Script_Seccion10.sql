
-- ===============================================================
-- 1. SUBQUERIES BÁSICAS
-- ===============================================================

-- Empleados contratados después que 'King' (adaptado de 'Vargas')
SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >
(SELECT hire_date
FROM employees
WHERE last_name = 'King');

-- Empleados en el mismo departamento que 'Kochhar' (adaptado de 'Grant')
SELECT last_name, department_id
FROM employees
WHERE department_id =
(SELECT department_id
FROM employees
WHERE last_name = 'Kochhar');

-- Empleados del departamento de 'IT' (adaptado de 'Marketing')
SELECT last_name, job_id, department_id
FROM employees
WHERE department_id =
(SELECT department_id
FROM departments
WHERE department_name = 'IT')
ORDER BY job_id;

-- ===============================================================
-- 2. SUBQUERIES CON MÚLTIPLES CONDICIONES
-- ===============================================================

-- Empleados con el mismo trabajo que el empleado ID 1 y en departamentos de Seattle
SELECT last_name, job_id, salary, department_id
FROM employees
WHERE job_id =
(SELECT job_id
FROM employees
WHERE employee_id = 1)
AND department_id IN
(SELECT department_id
FROM departments d
JOIN locations l ON d.location_id = l.location_id
WHERE l.city = 'Seattle');

-- ===============================================================
-- 3. SUBQUERIES CON FUNCIONES DE AGREGACIÓN
-- ===============================================================

-- Empleados con salario menor al promedio
SELECT last_name, salary
FROM employees
WHERE salary <
(SELECT AVG(salary)
FROM employees);

-- Departamentos con salario mínimo mayor al del departamento 10
SELECT department_id, MIN(salary) AS salario_minimo
FROM employees
GROUP BY department_id
HAVING MIN(salary) >
(SELECT MIN(salary)
FROM employees
WHERE department_id = 10);

-- ===============================================================
-- 4. SUBQUERIES QUE PUEDEN RETORNAR MÚLTIPLES VALORES
-- ===============================================================

-- Empleados con salario igual a algún salario del departamento 9
SELECT first_name, last_name, salary
FROM employees
WHERE salary IN
(SELECT salary
FROM employees
WHERE department_id = 9);

-- ===============================================================
-- 5. OPERADORES ALL Y ANY
-- ===============================================================

-- Empleados contratados antes que cualquiera del departamento 9
SELECT last_name, hire_date
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) < ALL
(SELECT EXTRACT(YEAR FROM hire_date)
FROM employees
WHERE department_id = 9
AND hire_date IS NOT NULL);

-- Empleados que son managers
SELECT last_name, employee_id
FROM employees
WHERE employee_id IN
(SELECT manager_id
FROM employees
WHERE manager_id IS NOT NULL);

-- Departamentos con salario mínimo menor a cualquier salario de departamentos 10 y 11
SELECT department_id, MIN(salary) AS salario_minimo
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING MIN(salary) < ANY
(SELECT salary
FROM employees
WHERE department_id IN (10, 11)
AND salary IS NOT NULL)
ORDER BY department_id;

-- ===============================================================
-- 6. SUBQUERIES CON MÚLTIPLES COLUMNAS
-- ===============================================================

-- Empleados con mismo manager y departamento que empleados 1 o 2 (adaptado de 149,174)
SELECT employee_id, manager_id, department_id, last_name
FROM employees
WHERE (manager_id, department_id) IN
(SELECT manager_id, department_id
FROM employees
WHERE employee_id IN (1, 2))
AND employee_id NOT IN (1, 2);

-- Versión alternativa usando subconsultas separadas
SELECT employee_id, manager_id, department_id, last_name
FROM employees
WHERE manager_id IN
(SELECT manager_id
FROM employees
WHERE employee_id IN (1, 2))
AND department_id IN
(SELECT department_id
FROM employees
WHERE employee_id IN (1, 2))
AND employee_id NOT IN (1, 2);

-- ===============================================================
-- 7. SUBQUERIES CON EXISTS
-- ===============================================================

-- Empleados que tienen el mismo trabajo que 'King' (adaptado de 'Ernst')
SELECT first_name, last_name, job_id
FROM employees
WHERE job_id IN
(SELECT job_id
FROM employees
WHERE last_name = 'King');

-- Empleados que tienen subordinados
SELECT DISTINCT e1.last_name, e1.employee_id
FROM employees e1
WHERE EXISTS
(SELECT 1
FROM employees e2
WHERE e2.manager_id = e1.employee_id);

-- ===============================================================
-- 8. CTE (WITH) - FUNCIONA IGUAL EN POSTGRESQL
-- ===============================================================

-- Empleados que NO son managers usando CTE
WITH managers AS
(SELECT DISTINCT manager_id
FROM employees
WHERE manager_id IS NOT NULL)
SELECT last_name AS "Not a manager", employee_id
FROM employees
WHERE employee_id NOT IN
(SELECT manager_id
FROM managers);

-- ===============================================================
-- 9. SUBQUERIES AVANZADAS
-- ===============================================================

-- Empleados con salario mayor al promedio de su departamento
SELECT e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary >
(SELECT AVG(e2.salary)
FROM employees e2
WHERE e2.department_id = e1.department_id);

-- Departamentos con más empleados que el promedio
SELECT department_id, COUNT(*) AS total_empleados
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING COUNT(*) >
(SELECT AVG(emp_count)
FROM (SELECT COUNT(*) AS emp_count
      FROM employees
      WHERE department_id IS NOT NULL
      GROUP BY department_id) AS dept_counts);

-- ===============================================================
-- 10. SUBQUERIES CORRELACIONADAS
-- ===============================================================

-- Empleados con el salario más alto de su departamento
SELECT e1.last_name, e1.salary, e1.department_id
FROM employees e1
WHERE e1.salary =
(SELECT MAX(e2.salary)
FROM employees e2
WHERE e2.department_id = e1.department_id);

-- Empleados contratados en el mismo año que su manager
SELECT e.last_name AS empleado, e.hire_date AS fecha_empleado, 
       m.last_name AS manager, m.hire_date AS fecha_manager
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
WHERE EXTRACT(YEAR FROM e.hire_date) = EXTRACT(YEAR FROM m.hire_date);

-- ===============================================================
-- 11. COMBINACIONES COMPLEJAS
-- ===============================================================

-- Top 3 empleados con mayor salario por departamento
SELECT department_id, last_name, salary
FROM (
    SELECT department_id, last_name, salary,
           ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rn
    FROM employees
    WHERE department_id IS NOT NULL
) ranked
WHERE rn <= 3
ORDER BY department_id, salary DESC;

-- Análisis comparativo de salarios
SELECT 
    last_name,
    salary,
    department_id,
    (SELECT AVG(salary) FROM employees) AS promedio_general,
    (SELECT AVG(salary) FROM employees e2 WHERE e2.department_id = e1.department_id) AS promedio_departamento
FROM employees e1
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;