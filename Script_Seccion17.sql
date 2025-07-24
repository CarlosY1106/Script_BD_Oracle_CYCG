-- SECCIÓN 15

CREATE USER scott WITH PASSWORD 'ur35scott';

ALTER USER scott WITH PASSWORD 'imscott35';

GRANT CONNECT, CREATE ON DATABASE postgres TO scott;

GRANT CREATE ON SCHEMA public TO scott;

CREATE ROLE manager;

GRANT CREATE ON SCHEMA public TO manager;

CREATE USER jennifer_cho WITH PASSWORD 'password123';
GRANT manager TO jennifer_cho;

CREATE USER scott_king WITH PASSWORD 'password123';
GRANT SELECT, INSERT ON copy_employees TO scott_king WITH GRANT OPTION;

GRANT SELECT ON copy_departments TO PUBLIC;

REVOKE SELECT, INSERT ON copy_employees FROM scott_king CASCADE;

REVOKE CREATE ON SCHEMA public FROM scott;

SELECT first_name, last_name
FROM employees
WHERE first_name ~ '^Ste(v|ph)en$';

SELECT first_name, last_name
FROM employees
WHERE first_name ~* '^ste(v|ph)en$';

SELECT last_name, 
       REGEXP_REPLACE(last_name, '^H[aeiou]', '**', 'i') AS "Name changed"
FROM employees;

DROP TABLE IF EXISTS my_contacts CASCADE;
CREATE TABLE my_contacts
(first_name VARCHAR(15),
last_name VARCHAR(15),
email VARCHAR(30) CHECK(email ~ '.+@.+\..+'));

INSERT INTO my_contacts VALUES ('John', 'Doe', 'john@example.com');
INSERT INTO my_contacts VALUES ('Jane', 'Smith', 'jane@test.org');

SELECT 'User and role management examples:' AS info;
SELECT 'PostgreSQL uses different privilege system than Oracle' AS note;

SELECT * FROM my_contacts;