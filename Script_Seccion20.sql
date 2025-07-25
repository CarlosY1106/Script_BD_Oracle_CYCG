-- SECCIÓN 20

DROP TABLE IF EXISTS emp CASCADE;
DROP TABLE IF EXISTS dept CASCADE;

CREATE TABLE dept
AS SELECT * FROM departments;

ALTER TABLE dept
ADD CONSTRAINT dept_pk PRIMARY KEY (department_id);

CREATE TABLE emp
AS SELECT * FROM employees;

ALTER TABLE emp
ADD CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES dept(department_id)
ON DELETE CASCADE;

SELECT COUNT(*) AS "Num emps"
FROM emp;

SELECT 'Available departments:' AS info;
SELECT department_id, department_name FROM dept ORDER BY department_id LIMIT 5;

DELETE FROM dept
WHERE department_id = 10;

SELECT COUNT(*) AS "Num emps after delete"
FROM emp;

DROP SEQUENCE IF EXISTS ct_seq CASCADE;
CREATE SEQUENCE ct_seq
START WITH 1000
INCREMENT BY 1;

WITH valid_dept AS (
    SELECT department_id FROM dept LIMIT 1
)
INSERT INTO emp
(employee_id, first_name, last_name, email, phone_number,
hire_date, job_id, salary, commission_pct, manager_id, department_id)
SELECT 
    NEXTVAL('ct_seq'), 'Kaare', 'Hansen', 'KHANSEN', '4496583212',
    CURRENT_DATE, 'IT_PROG', 6500, NULL, 100, v.department_id
FROM valid_dept v;

CREATE INDEX emp_indx ON emp(employee_id DESC, 
UPPER(SUBSTRING(first_name, 1, 1) || ' ' || last_name));

SELECT 
    grantee,
    privilege_type,
    is_grantable
FROM information_schema.table_privileges
WHERE table_name = 'emp'
AND table_schema = CURRENT_SCHEMA();

SELECT 'Table operations completed successfully' AS status;

SELECT employee_id, first_name, last_name, department_id
FROM emp 
WHERE employee_id >= 1000;

SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS emp_count
FROM dept d
LEFT JOIN emp e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;