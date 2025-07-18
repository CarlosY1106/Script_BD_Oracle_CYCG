--  Diapositiva 2.1 

-- Crear tabla departments
CREATE TABLE IF NOT EXISTS departments (
    department_id   INTEGER PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL
);

-- Crear tabla employees
CREATE TABLE IF NOT EXISTS employees (
    employee_id INTEGER PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    salary      DECIMAL(10,2)
);

-- Crear tabla clients
CREATE TABLE IF NOT EXISTS clients (
    client_id   INTEGER PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    phone       VARCHAR(20),
    address     TEXT
);

-- Insertar datos en departments evitando duplicados
INSERT INTO departments (department_id, department_name)
VALUES 
    (10, 'Administration'),
    (20, 'Marketing'),
    (30, 'Shipping'),
    (40, 'IT')
ON CONFLICT (department_id) DO NOTHING;

-- Insertar datos en employees (especificando IDs para evitar conflictos)
INSERT INTO employees (employee_id, first_name, last_name, salary)
VALUES 
    (1, 'Ellen', 'Abel', 12000),
    (2, 'Curtis', 'Davies', 15000),
    (3, 'Lex', 'De Haan', 20000)
ON CONFLICT (employee_id) DO NOTHING;

-- Insertar clientes
INSERT INTO clients (client_id, first_name, last_name, email, phone, address)
VALUES 
    (1, 'Ana', 'Ramírez', 'ana.ramirez@example.com', '987654321', 'Colonia Centro, La Ceiba'),
    (2, 'Luis', 'Martínez', 'luis.martinez@example.com', '998877665', 'Barrio Inglés, La Ceiba'),
    (3, 'Sofía', 'González', 'sofia.gonzalez@example.com', '912345678', 'Zona Viva, La Ceiba')
ON CONFLICT (email) DO NOTHING;

-- Consultar todos los datos
SELECT 'Departments:' as table_info;
SELECT * FROM departments;

SELECT 'Employees:' as table_info;
SELECT * FROM employees;

SELECT 'Clients:' as table_info;
SELECT * FROM clients;