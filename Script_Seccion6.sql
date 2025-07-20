-- Seccion 6

DROP TABLE IF EXISTS job_history CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS jobs CASCADE;
DROP TABLE IF EXISTS departments CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS job_grades CASCADE;


CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(50),
    state_province VARCHAR(25),
    country_id VARCHAR(2)
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    manager_id INTEGER,
    location_id INTEGER REFERENCES locations(location_id)
);

CREATE TABLE jobs (
    job_id VARCHAR(10) PRIMARY KEY,
    job_title VARCHAR(50) NOT NULL,
    min_salary NUMERIC(8,2),
    max_salary NUMERIC(8,2)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50),
    phone_number VARCHAR(20),
    hire_date DATE,
    job_id VARCHAR(10) REFERENCES jobs(job_id),
    salary NUMERIC(10,2),
    commission_pct DECIMAL(3,2),
    manager_id INTEGER REFERENCES employees(employee_id),
    department_id INTEGER REFERENCES departments(department_id)
);


CREATE TABLE job_history (
    employee_id INTEGER REFERENCES employees(employee_id),
    start_date DATE,
    end_date DATE,
    job_id VARCHAR(10) REFERENCES jobs(job_id),
    department_id INTEGER REFERENCES departments(department_id),
    PRIMARY KEY (employee_id, start_date)
);


CREATE TABLE job_grades (
    grade_level VARCHAR(2) PRIMARY KEY,
    lowest_sal NUMERIC(8,2),
    highest_sal NUMERIC(8,2)
);

-- ===============================================================
-- PASO 2: Insertar datos de muestra
-- ===============================================================


INSERT INTO locations (city, state_province, country_id) VALUES
('Seattle', 'Washington', 'US'),
('Toronto', 'Ontario', 'CA'),
('London', 'England', 'UK'),
('Geneva', 'Geneva', 'CH'),
('Munich', 'Bavaria', 'DE');


INSERT INTO departments (department_name, location_id) VALUES
('Administration', 1),
('Marketing', 1),
('Purchasing', 2),
('Human Resources', 1),
('Shipping', 3),
('IT', 1),
('Public Relations', 4),
('Sales', 5),
('Executive', 1),
('Finance', 1),
('Accounting', 1);


INSERT INTO jobs (job_id, job_title, min_salary, max_salary) VALUES
('AD_PRES', 'President', 20000, 40000),
('AD_VP', 'Administration Vice President', 15000, 30000),
('AD_ASST', 'Administration Assistant', 3000, 6000),
('FI_MGR', 'Finance Manager', 8200, 16000),
('FI_ACCOUNT', 'Accountant', 4200, 9000),
('AC_MGR', 'Accounting Manager', 8200, 16000),
('AC_ACCOUNT', 'Public Accountant', 4200, 9000),
('SA_MAN', 'Sales Manager', 10000, 20000),
('SA_REP', 'Sales Representative', 6000, 12000),
('PU_MAN', 'Purchasing Manager', 8000, 15000),
('ST_MAN', 'Stock Manager', 5500, 8500),
('IT_PROG', 'Programmer', 4000, 10000),
('MK_MAN', 'Marketing Manager', 9000, 15000),
('MK_REP', 'Marketing Representative', 4000, 9000),
('HR_REP', 'Human Resources Representative', 4000, 9000),
('PR_REP', 'Public Relations Representative', 4500, 10500),
('SH_CLERK', 'Shipping Clerk', 2500, 5500),
('ST_CLERK', 'Stock Clerk', 2000, 5000),
('PU_CLERK', 'Purchasing Clerk', 2500, 5500);

INSERT INTO employees (first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) VALUES
('Steven', 'King', 'SKING', '515.123.4567', '1987-06-17', 'AD_PRES', 24000, NULL, NULL, 9),
('Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '1989-09-21', 'AD_VP', 17000, NULL, 1, 9),
('Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '1993-01-13', 'AD_VP', 17000, NULL, 1, 9),
('Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '1990-01-03', 'IT_PROG', 9000, NULL, 2, 6),
('Bruce', 'Ernst', 'BERNST', '590.423.4568', '1991-05-21', 'IT_PROG', 6000, NULL, 4, 6),
('David', 'Austin', 'DAUSTIN', '590.423.4569', '1997-06-25', 'IT_PROG', 4800, NULL, 4, 6),
('Valli', 'Pataballa', 'VPATABAL', '590.423.4560', '1998-02-05', 'IT_PROG', 4800, NULL, 4, 6),
('Diana', 'Lorentz', 'DLORENTZ', '590.423.5567', '1999-02-07', 'IT_PROG', 4200, NULL, 4, 6),
('Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '1994-08-17', 'FI_MGR', 12000, NULL, 1, 10),
('Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '1994-08-16', 'FI_ACCOUNT', 9000, NULL, 9, 10),
('John', 'Chen', 'JCHEN', '515.124.4269', '1997-09-28', 'FI_ACCOUNT', 8200, NULL, 9, 10),
('Ismael', 'Sciarra', 'ISCIARRA', '515.124.4369', '1997-09-30', 'FI_ACCOUNT', 7700, NULL, 9, 10),
('Jose Manuel', 'Urman', 'JMURMAN', '515.124.4469', '1998-03-07', 'FI_ACCOUNT', 7800, NULL, 9, 10),
('Luis', 'Popp', 'LPOPP', '515.124.4567', '1999-12-07', 'FI_ACCOUNT', 6900, NULL, 9, 10),
('Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '1994-12-07', 'PU_MAN', 11000, NULL, 1, 3),
('Alexander', 'Khoo', 'AKHOO', '515.127.4562', '1995-05-18', 'PU_CLERK', 3100, NULL, 15, 3),
('Shelley', 'Higgins', 'SHIGGINS', '515.123.8080', '1994-06-07', 'AC_MGR', 12000, NULL, 1, 11),
('William', 'Gietz', 'WGIETZ', '515.123.8181', '1994-06-07', 'AC_ACCOUNT', 8300, NULL, 17, 11);


UPDATE departments SET manager_id = 1 WHERE department_id = 9; -- King manages Executive
UPDATE departments SET manager_id = 2 WHERE department_id = 1; -- Kochhar manages Administration
UPDATE departments SET manager_id = 4 WHERE department_id = 6; -- Hunold manages IT
UPDATE departments SET manager_id = 9 WHERE department_id = 10; -- Greenberg manages Finance
UPDATE departments SET manager_id = 15 WHERE department_id = 3; -- Raphaely manages Purchasing
UPDATE departments SET manager_id = 17 WHERE department_id = 11; -- Higgins manages Accounting


INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id) VALUES
(1, '1987-06-17', '1993-07-24', 'AD_ASST', 9),
(2, '1989-09-21', '1997-06-19', 'AC_ACCOUNT', 11),
(3, '1993-01-13', '1998-07-24', 'IT_PROG', 6);


INSERT INTO job_grades (grade_level, lowest_sal, highest_sal) VALUES
('A', 1000, 2999),
('B', 3000, 5999),
('C', 6000, 9999),
('D', 10000, 14999),
('E', 15000, 24999),
('F', 25000, 40000);

-- ===============================================================
-- PASO 3: CONSULTAS ORIGINALES CONVERTIDAS A POSTGRESQL
-- ===============================================================

SELECT 'VERIFICACIÓN DE TABLAS' AS info;
SELECT 'Total employees: ' || COUNT(*) AS count FROM employees;
SELECT 'Total departments: ' || COUNT(*) AS count FROM departments;
SELECT 'Total jobs: ' || COUNT(*) AS count FROM jobs;
SELECT 'Total locations: ' || COUNT(*) AS count FROM locations;


SELECT '=== NATURAL JOIN EXAMPLES ===' AS section;

SELECT first_name, last_name, e.job_id, job_title
FROM employees e NATURAL JOIN jobs j
WHERE department_id > 80;

--
SELECT department_name, city
FROM departments NATURAL JOIN locations;


SELECT '=== CROSS JOIN EXAMPLE ===' AS section;

SELECT last_name, department_name
FROM employees CROSS JOIN departments
LIMIT 10;

-- 4. JOIN USING
SELECT '=== JOIN USING EXAMPLES ===' AS section;

SELECT first_name, last_name, department_id, department_name
FROM employees JOIN departments USING (department_id);

SELECT first_name, last_name, department_id, department_name
FROM employees JOIN departments USING (department_id)
WHERE last_name = 'Higgins';

-- 5. JOIN con ON
SELECT '=== JOIN WITH ON EXAMPLES ===' AS section;

SELECT last_name, job_title
FROM employees e JOIN jobs j
ON (e.job_id = j.job_id);

SELECT last_name, job_title
FROM employees e JOIN jobs j
ON (e.job_id = j.job_id)
WHERE last_name LIKE 'H%';


SELECT '=== JOIN WITH BETWEEN ===' AS section;

SELECT last_name, salary, grade_level, lowest_sal, highest_sal
FROM employees JOIN job_grades
ON(salary BETWEEN lowest_sal AND highest_sal)
ORDER BY salary;


SELECT '=== MULTIPLE JOINS ===' AS section;

SELECT last_name, department_name AS "Department", city
FROM employees 
JOIN departments USING (department_id)
JOIN locations USING (location_id);


SELECT '=== OUTER JOIN EXAMPLES ===' AS section;


SELECT e.last_name, d.department_id, d.department_name
FROM employees e LEFT OUTER JOIN departments d
ON (e.department_id = d.department_id);


SELECT e.last_name, d.department_id, d.department_name
FROM employees e RIGHT OUTER JOIN departments d
ON (e.department_id = d.department_id);


SELECT e.last_name, d.department_id, d.department_name
FROM employees e FULL OUTER JOIN departments d
ON (e.department_id = d.department_id);


SELECT last_name, e.job_id AS "Job", jh.job_id AS "Old job", end_date
FROM employees e LEFT OUTER JOIN job_history jh
ON(e.employee_id = jh.employee_id);


SELECT '=== SELF JOIN EXAMPLES ===' AS section;

SELECT worker.last_name || ' works for ' || manager.last_name AS "Works for"
FROM employees worker JOIN employees manager
ON (worker.manager_id = manager.employee_id);

SELECT worker.last_name, worker.manager_id, manager.last_name AS "Manager name"
FROM employees worker JOIN employees manager
ON (worker.manager_id = manager.employee_id);

-- ===============================================================
-- PASO 4: CONSULTAS JERÁRQUICAS - POSTGRESQL EQUIVALENTES (CORREGIDAS)
-- ===============================================================

SELECT '=== HIERARCHICAL QUERIES - POSTGRESQL VERSION ===' AS section;


WITH RECURSIVE hierarchy AS (
    -- Anchor member (equivalente a START WITH)
    SELECT employee_id, last_name, job_id, manager_id, 1 as level
    FROM employees
    WHERE employee_id = 1  -- Steven King
    
    UNION ALL
    
 
    SELECT e.employee_id, e.last_name, e.job_id, e.manager_id, h.level + 1
    FROM employees e
    INNER JOIN hierarchy h ON e.manager_id = h.employee_id
)
SELECT employee_id, last_name, job_id, manager_id, level
FROM hierarchy
ORDER BY level, last_name;


WITH RECURSIVE hierarchy_names AS (
    -- Anchor: Start with King
    SELECT employee_id, last_name, last_name::TEXT as path, 1 as level
    FROM employees
    WHERE last_name = 'King'
    
    UNION ALL
    

    SELECT e.employee_id, e.last_name, 
           (h.path || ' -> ' || e.last_name)::TEXT as path, 
           h.level + 1
    FROM employees e
    INNER JOIN hierarchy_names h ON e.manager_id = h.employee_id
)
SELECT last_name || ' reports to hierarchy: ' || path AS "Walk Top Down"
FROM hierarchy_names
WHERE level > 1
ORDER BY level, last_name;


WITH RECURSIVE org_chart AS (

    SELECT employee_id, last_name, last_name::TEXT as chart_display, 1 as level
    FROM employees
    WHERE last_name = 'King'
    
    UNION ALL
    
    SELECT e.employee_id, e.last_name,
           (REPEAT('  ', oc.level) || '└─ ' || e.last_name)::TEXT as chart_display,
           oc.level + 1
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT chart_display AS "Org Chart"
FROM org_chart
ORDER BY employee_id;

