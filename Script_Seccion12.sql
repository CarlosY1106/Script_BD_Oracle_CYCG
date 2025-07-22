-- SECCION 12

DROP TABLE IF EXISTS copy_employees CASCADE;
DROP TABLE IF EXISTS copy_departments CASCADE;

CREATE TABLE copy_employees
AS (SELECT * FROM employees);

CREATE TABLE copy_departments
AS (SELECT * FROM departments);

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'copy_employees'
ORDER BY ordinal_position;

SELECT * FROM copy_employees;

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'copy_departments'
ORDER BY ordinal_position;

SELECT * FROM copy_departments;

INSERT INTO copy_departments
(department_id, department_name, manager_id, location_id)
VALUES (200, 'Human Resources', 205, 1500);

INSERT INTO copy_departments
VALUES (210, 'Estate Management', 102, 1700);

INSERT INTO copy_employees
(employee_id, first_name, last_name, phone_number, hire_date, job_id, salary)
VALUES
(302, 'Grigorz', 'Polanski', '8586667641', '2017-06-15', 'IT_PROG', 4200);

INSERT INTO copy_employees
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary)
VALUES
(303, 'Grigorz', 'Polanski', 'gpolanski', NULL, '2017-06-15', 'IT_PROG', 4200);

INSERT INTO copy_employees
(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary)
VALUES
(304, 'Test', CURRENT_USER, 't_user', '4159982010', CURRENT_DATE, 'ST_CLERK', 2500);

SELECT 
    first_name, 
    TO_CHAR(hire_date, 'Month, FMDD, YYYY') AS formatted_hire_date
FROM employees
WHERE employee_id = 1;

SELECT 
    first_name,
    TO_CHAR(hire_date, 'Month DD, YYYY') AS formato1,
    TO_CHAR(hire_date, 'FMMonth FMDD, YYYY') AS formato2,
    TO_CHAR(hire_date, 'Day, Month DD, YYYY') AS formato3
FROM employees
WHERE employee_id <= 3;

SELECT 'Departamentos agregados:' AS info;
SELECT * FROM copy_departments WHERE department_id >= 200;

SELECT 'Empleados agregados:' AS info;
SELECT * FROM copy_employees WHERE employee_id >= 302;

SELECT 
    CURRENT_USER AS usuario_actual,
    CURRENT_DATE AS fecha_actual,
    CURRENT_TIMESTAMP AS timestamp_actual,
    NOW() AS now_postgresql;

SELECT 
    column_name,
    data_type,
    character_maximum_length,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_name = 'copy_employees'
ORDER BY ordinal_position;

SELECT
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type,
    kcu.column_name
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu 
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.table_name IN ('copy_employees', 'copy_departments')
ORDER BY tc.table_name, tc.constraint_name;