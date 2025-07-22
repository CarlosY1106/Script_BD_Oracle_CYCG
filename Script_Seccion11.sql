--SECCION 11

SELECT 
    SUBSTR(first_name, 1, 1) || ' ' || last_name AS "Employee Name",
    salary AS "Salary",
    CASE 
        WHEN commission_pct IS NULL THEN 'No' 
        ELSE 'Yes' 
    END AS "Commission"
FROM employees;