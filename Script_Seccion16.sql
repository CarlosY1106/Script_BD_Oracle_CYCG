-- SECCIÓN 16

CREATE SEQUENCE IF NOT EXISTS runner_id_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 50000
NO CYCLE
CACHE 1;

SELECT 
    sequence_name, 
    minimum_value as min_value, 
    maximum_value as max_value, 
    increment as increment_by
FROM information_schema.sequences
WHERE sequence_schema = CURRENT_SCHEMA();

DROP SEQUENCE IF EXISTS departments_seq CASCADE;
CREATE SEQUENCE departments_seq
INCREMENT BY 1
START WITH 300
MAXVALUE 9999
NO CYCLE
CACHE 1;

DROP SEQUENCE IF EXISTS employees_seq CASCADE;
CREATE SEQUENCE employees_seq
INCREMENT BY 1
START WITH 500
MAXVALUE 99999
NO CYCLE
CACHE 1;

INSERT INTO copy_departments
(department_id, department_name, location_id)
VALUES (NEXTVAL('departments_seq'), 'Support', 2500);

INSERT INTO copy_employees
(employee_id, first_name, last_name, email, hire_date, job_id, department_id)
VALUES (NEXTVAL('employees_seq'), 'Test', 'User', 'test@company.com', CURRENT_DATE, 'IT_PROG', CURRVAL('departments_seq'));

SELECT 
    sequence_name, 
    minimum_value as min_value, 
    maximum_value as max_value
FROM information_schema.sequences
WHERE sequence_name = 'runner_id_seq'
AND sequence_schema = CURRENT_SCHEMA();

SELECT 'Sequence examples:' AS info;
SELECT 'NEXTVAL(''sequence_name'') - Get next value' AS syntax1;
SELECT 'CURRVAL(''sequence_name'') - Get current value' AS syntax2;
SELECT 'SETVAL(''sequence_name'', value) - Set sequence value' AS syntax3;

SELECT NEXTVAL('runner_id_seq') AS first_value;

SELECT 
    'Current value of runner_id_seq: ' || CURRVAL('runner_id_seq') AS current_value,
    'Next value will be: ' || NEXTVAL('runner_id_seq') AS next_value;