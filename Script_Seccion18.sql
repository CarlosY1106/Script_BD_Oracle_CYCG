-- SECCIÓN 18

BEGIN;

UPDATE copy_departments
SET manager_id = 101
WHERE department_id = 60;

SAVEPOINT one;

INSERT INTO copy_departments(department_id, department_name, manager_id, location_id)
VALUES(130, 'Estate Management', 102, 1500);

ROLLBACK TO SAVEPOINT one;

COMMIT;

SELECT 'Transaction completed - UPDATE was kept, INSERT was rolled back' AS transaction_result;

SELECT department_id, department_name, manager_id, location_id 
FROM copy_departments 
WHERE department_id IN (60, 130);

BEGIN;

UPDATE copy_departments
SET manager_id = 102
WHERE department_id = 50;

SAVEPOINT checkpoint_1;

INSERT INTO copy_departments(department_id, department_name, manager_id, location_id)
VALUES(140, 'Research & Development', 103, 1600);

SAVEPOINT checkpoint_2;

UPDATE copy_departments
SET department_name = 'R&D Department'
WHERE department_id = 140;

ROLLBACK TO SAVEPOINT checkpoint_1;

COMMIT;

SELECT 'Second transaction example completed' AS info;
SELECT * FROM copy_departments WHERE department_id IN (50, 140);