-- SECCION 13

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'jobs'
ORDER BY ordinal_position;

SELECT *
FROM mary.students;

DROP TABLE IF EXISTS my_cd_collection CASCADE;
CREATE TABLE my_cd_collection
(cd_number NUMERIC(3),
title VARCHAR(20),
artist VARCHAR(20),
purchase_date DATE DEFAULT CURRENT_DATE);

DROP TABLE IF EXISTS my_friends CASCADE;
CREATE TABLE my_friends
(first_name VARCHAR(20),
last_name VARCHAR(30),
email VARCHAR(30),
phone_num VARCHAR(12),
birth_date DATE);

SELECT table_name, 'VALID' as status
FROM information_schema.tables
WHERE table_schema = CURRENT_SCHEMA();

SELECT table_name, 'VALID' as status
FROM information_schema.tables
WHERE table_schema = 'public';

SELECT indexname as index_name, tablename as table_name
FROM pg_indexes
WHERE schemaname = CURRENT_SCHEMA();

SELECT sequence_name
FROM information_schema.sequences
WHERE sequence_schema = CURRENT_SCHEMA();

DROP TABLE IF EXISTS time_ex1 CASCADE;
CREATE TABLE time_ex1
(exact_time TIMESTAMP);

INSERT INTO time_ex1
VALUES ('2017-06-10 10:52:29.123456');

DROP TABLE IF EXISTS time_ex3 CASCADE;
CREATE TABLE time_ex3
( first_column TIMESTAMP WITH TIME ZONE,
second_column TIMESTAMP WITH TIME ZONE);

INSERT INTO time_ex3
(first_column, second_column)
VALUES
('2017-07-15 08:00:00-07:00', '2007-11-15 08:00:00');

SELECT 'Example ALTER TABLE syntax:' AS info;
SELECT 'ALTER TABLE tablename ADD COLUMN column_name data_type DEFAULT expression;' AS syntax_example;
