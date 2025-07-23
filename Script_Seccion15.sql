-- SECCION 15

CREATE OR REPLACE VIEW view_employees
AS SELECT employee_id, first_name, last_name, email
FROM employees
WHERE employee_id BETWEEN 100 AND 124;

SELECT *
FROM view_employees;

CREATE OR REPLACE VIEW view_dept50
AS SELECT department_id, employee_id, first_name, last_name, salary
FROM copy_employees
WHERE department_id = 50;

UPDATE view_dept50
SET department_id = 90
WHERE employee_id = 124;

CREATE OR REPLACE VIEW view_dept50_readonly
AS SELECT department_id, employee_id, first_name, last_name, salary
FROM employees
WHERE department_id = 50;

SELECT 
    ROW_NUMBER() OVER (ORDER BY hire_date) AS "Longest employed", 
    last_name, 
    hire_date
FROM employees
ORDER BY hire_date
LIMIT 5;

CREATE OR REPLACE VIEW view_high_salary_employees
AS SELECT 
    department_id AS "Department ID", 
    MAX(salary) AS "Highest salary"
FROM employees
GROUP BY department_id;

SELECT * FROM view_high_salary_employees;

CREATE OR REPLACE VIEW view_it_employees
AS SELECT employee_id, first_name, last_name, job_id, salary
FROM employees
WHERE job_id LIKE 'IT_%';

SELECT * FROM view_it_employees
ORDER BY salary DESC;