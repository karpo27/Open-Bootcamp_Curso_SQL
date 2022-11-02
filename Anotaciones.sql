-- Creación de Tablas:
CREATE TABLE IF NOT EXISTS employees(
	id SERIAL PRIMARY KEY,
	name VARCHAR (250) NOT NULL,
	email VARCHAR (100) UNIQUE,
	married BOOLEAN,
	genre CHAR (1),
	salary NUMERIC (9,2) CHECK (salary >= 12000),
	birth_date DATE CHECK (birth_date > '1975-01-01'),
	start_at TIME
	
);

-- Ver datos de una tabla:
SELECT * FROM employees;

-- Insertar datos:
INSERT INTO employees (name, email, married, genre, salary, birth_date, start_at) VALUES
	('Juan', 'juan@hotmail.com', TRUE, 'M', 14000.2, '1990-12-25', '08:00:00'),
	('Maria', 'MariaDB@hotmail.com', FALSE, 'F', 15500.34, '1989-09-27', '08:30:00'),
	('Pedro', 'pedro@hotmail.com', TRUE, 'M', 19000.04, '1994-03-24', '09:00:00')

-- Tipos de datos: 
-- INT
-- CHAR, VARCHAR, TEXT
-- BOOLEAN
-- NUMERIC
-- DATE
-- TIME

-- Identificador único:
-- id SERIAL PRIMARY KEY (sin primary key se pueden insertar duplicados)

-- Hacer que un campo sea obligatorio:
-- agregar NOT NULL

-- Hacer que un campo sea único (sin tener repeticiones):
-- agregar UNIQUE

-- Restricciones en rangos de datos:
-- agregar CHECK + "(condicion)"

-- Renombrar tabla:
ALTER TABLE IF EXISTS employees RENAME TO employees_2022:

-- Agregar columnas:
ALTER TABLE employees ADD COLUMN email VARCHAR (100);

-- Borrar columnas:
ALTER TABLE employees DROP COLUMN IF EXISTS salary;

-- Borrar tabla:
DROP TABLE IF EXISTS employees;

-- Sentencias DML: Data Manipulation Language
-- CRUD: 
-- Create (INSERT INTO)
-- Read (SELECT FROM)
-- Update (UPDATE SET)
-- Delete (DELETE FROM)

-- 1. Consultas o recuperacion de datos:

SELECT * FROM employees;

SELECT id FROM employees;

SELECT id, email FROM employees;

-- Filtrar filas:

SELECT * FROM employees WHERE name = 'Patricia';

SELECT * FROM employees WHERE id = 1;

SELECT * FROM employees WHERE married = TRUE and salary > 10000

-- 2. Inserción de datos:

INSERT INTO employees (name, email) VALUES ('Juan', 'juan@hotmail.com');

-- 3. Actualizar o editar datos:

UPDATE employees SET birth_date = '1997-03-02'; 

UPDATE employees SET birth_date = '1997-03-02' WHERE id = 5;

UPDATE employees SET genre = 'M', salary = 45000 WHERE email = jui@hotmail.com;

UPDATE employees SET genre = 'M', salary = 45000 WHERE email = juino@hotmail.com RETURNING *;

-- 4. Borrar datos:

DELETE FROM employees WHERE  married = TRUE;

DELETE FROM employees WHERE  salary < 33000;

DELETE FROM employees WHERE  salary IS NULL;

-- Explorar Tablas:

SELECT * FROM actor;

SELECT * FROM actor WHERE last_name = 'WAHLBERG'

SELECT * FROM address WHERE district = 'California';

SELECT * FROM address WHERE district = 'California' AND postal_code = '1234' OR postal_code = '1333';

SELECT * FROM city WHERE city LIKE 'A%';
-- traer registros de tabla city en columna llamada city donde los registros comiencen con 'A'

SELECT * FROM film WHERE description LIKE '%Drama%'
-- traer registros de tabla film en columna description donde haya la palabra 'Drama' sin importar posición

-- Mas ejemplos de tablas:
CREATE TABLE manufacturer(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	num_employees INT,
	CONSTRAINT pk_manufacturer PRIMARY KEY(id)
);

CREATE TABLE model(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	id_manufacturer INT,
	CONSTRAINT pk_model PRIMARY KEY(id),
	CONSTRAINT fk_model_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES manufacturer(id)
);

CREATE TABLE version(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	engine VARCHAR(50),
	price NUMERIC,
	cc NUMERIC(3, 2)
	id_model INT
	CONSTRAINT pk_version PRIMARY KEY(id)
	CONSTRAINT fk_version_model FOREIGN KEY (id_model) REFERENCES model(id) ON UPDATE cascade ON DELETE cascade
);

SELECT * FROM version;

INSERT INTO version (name, engine, price, cc, id_model) VALUES
	('Basic', 'Diesel 4C', 30000, 1.9, 2),
	('Medium', 'Diesel 5C', 50000, 2.2, 2),
	('Advance', 'Diesel 6C', 80000, 3.2, 2),
	('Sport', 'Gasolina 4C', 50000, 2.1, 3),
	('Sport Advance', 'Gasolina 8C', 90000, 3.2, 3)

CREATE TABLE extra(
	id SERIAL,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(300)
	CONSTRAINT pk_extra PRIMARY KEY(id)
);

CREATE TABLE extra_version(
	id_version INT,
	id_extra INT,
	price NUMERIC NOT NULL CHECK (price >= 0),
	CONSTRAINT pk_extra_version PRIMARY KEY (id_version, id_extra),
	CONSTRAINT fk_version_extra FOREIGN KEY (id_version) REFERENCES version(id) ON UPDATE cascade ON DELETE cascade,
	CONSTRAINT fk_extra_version FOREIGN KEY (id_extra) REFERENCES extra(id) ON UPDATE cascade ON DELETE cascade
);

INSERT INTO extra (name, description) VALUES
	('Techo solar', 'Techo solar flamante lorem ipsum...'),
	('Climatizador', 'lorem ipsum...'),
	('Wifi', 'lorem ipsum...'),
	('Levas', 'lorem ipsum...')

INSERT INTO extra_version VALUES (1, 1, 3000);
INSERT INTO extra_version VALUES (1, 2, 1000);
INSERT INTO extra_version VALUES (1, 3, 500);

CREATE TABLE employee(
	id SERIAL,
	nif VARCHAR(9) NOT NULL UNIQUE,
	phone VARCHAR(15),
	CONSTRAINT pk_id PRIMARY KEY (id)
);

INSERT INTO employee(name, nif, phone) VALUES
	('Bob', '123455', '678967543'),
	('Mike', '156345', '5682367543'),


CREATE TABLE customer(
	id SERIAL,
	name VARCHAR(50),
	email VARCHAR(50) NOT NULL UNIQUE,
	CONSTRAINT pk_id PRIMARY KEY (id)
);

INSERT INTO customer(name, email) VALUES
	('customer1', 'c1@gmail.com'),
	('customer2', 'c2@gmail.com')

CREATE TABLE vehicle(
	id SERIAL,
	license_num VARCHAR(8),
	creation_date DATE,
	price_gross NUMERIC,
	price_net NUMERIC,
	type VARCHAR(30),

	id_manufacturer INT,
	id_model INT,
	id_version INT,
	id_extra INT,

	CONSTRAINT pk_vehicle PRIMARY KEY (id),
	CONSTRAINT fk_vehicle_manufacturer FOREIGN KEY (id_manufacturer) REFERENCES manufacturer(id),
	CONSTRAINT fk_vehicle_model FOREIGN KEY (id_model) REFERENCES model(id),
	CONSTRAINT fk_vehicle_version FOREIGN KEY (id_version, id_extra) REFERENCES extra_version(id_version, id_extra)
);

INSERT INTO vehicle(license_num, price_gross, id_manufacturer, id_model, id_version, id_extra) VALUES
	('1234NMJK', 40000, 1, 2, 1, 2),
	('51234RMTT', 60000, 1, 3, 3, 3)

CREATE TABLE sale(
	id SERIAL,
	sale_date DATE,
	channel VARCHAR(300),

	id_vehicle INT,
	id_employee INT,
	id_customer INT,

	CONSTRAINT pk_sale PRIMARY KEY (id),
	CONSTRAINT fk_sale_vehicle FOREIGN KEY (id_vehicle) REFERENCES vehicle(id),
	CONSTRAINT fk_sale_employee FOREIGN KEY (id_employee) REFERENCES employee(id),
	CONSTRAINT fk_sale_customer FOREIGN KEY (id_customer) REFERENCES customer(id)
);

INSERT INTO sale(sale_date, channel, id_vehicle, id_employee, id_customer) VALUES
	('2022-01-01', 'Phone', 1, 1, 1);

----------------------------------------------------------------------------------

-- Para filtrar algunos resultados (cuando hay muchos datos):

-- X
SELECT * FROM address;

-- X
SELECT district FROM address;

-- DISTINCT: quita repetidos
SELECT DISTINCT district FROM address;

-- AND, OR, NOT:
SELECT * FROM address WHERE district != 'California';
SELECT * FROM address WHERE NOT district = 'California';
SELECT * FROM address WHERE district IS NOT NULL;

SELECT * FROM address WHERE district = 'Abu Dhabi' OR 'California';

SELECT * FROM address WHERE district = 'Abu Dhabi' AND 'California';

-- GROUP BY:
-- Contar cuantos address hay en cada distrito CON Funcion: COUNT()
SELECT district, COUNT(district) FROM address GROUP BY district; 
SELECT district, COUNT(district) FROM address GROUP BY district ORDER BY district;

-- stock de una pelicula en base a su titulo:
SELECT * FROM inventory

SELECT f.title, COUNT(i.inventory_id) as unidades FROM film f INNER JOIN inventory i ON i.film_id = f.film_id
WHERE title = 'ACADEMY DINOSAUR' GROUP BY title ORDER BY unidades DESC;

-- Funcion: SUM()
SELECT * FROM customer;
SELECT * FROM payment;

SELECT c.email, COUNT(p.payment_id) as num_pagos FROM payment p INNER JOIN customer c ON p.customer_id = c.customer_id
GROUP BY c.email

-- cambia nombre a la columna count:
SELECT district, COUNT(district) AS num FROM address GROUP BY district; 

-- JOIN:
SELECT * FROM customer;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM country;

-- consulta a 2 tablas: customer y address:
SELECT first_name, last_name, customer.address_id, address FROM customer --(especificaciones por ambiguedad)
	INNER JOIN address ON customer.address_id = address.address_id;

SELECT * FROM customer --(especificaciones por ambiguedad, lleva mas tiempo ya que trae todos los datos)
	INNER JOIN address ON customer.address_id = address.address_id;

-- consulta a 3 tablas: customer, address y city:
SELECT cu.email, a.address_id, ci.city address FROM customer cu
	INNER JOIN address ON cu.address_id = a.address_id
	INNER JOIN city ON city_id = ci.city_id;

-- consulta a 4 tablas: customer, address, city y country:
SELECT cu.email, a.address_id, ci.city, co.country address FROM customer cu
	INNER JOIN address ON customer.address_id = address.address_id
	INNER JOIN city ON city_id = ci.city_id;
	INNER JOIN country co ON ci.country_id = co.country_id


-- Funcion: CONCAT()
SELECT * FROM actor;

SELECT CONCAT(first_name, '', last_name) FROM actor;

SELECT CONCAT(first_name, '', last_name) AS full_name FROM actor;

-- LIKE:
SELECT * FROM films;

SELECT * FROM film WHERE description LIKE '%Monastery';
SELECT * FROM film WHERE description LIKE '%Drama%';

SELECT * FROM actor WHERE last_name LIKE '%LI%';
-- Orden ascendente: empieza por el principio y va hasta el final
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name;
-- Orden descendente: empieza por el final y va hasta el principio
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name DESC;

-- IN:
SELECT * FROM country;

SELECT * FROM country WHERE country = 'Spain';
SELECT * FROM country WHERE country = 'Spain' or country = 'Germany';
SELECT * FROM country WHERE country IN(
	'Spain',
	'Germany',
	'France'
);

-- SUB-QUERIES: Select dentro de otro Select
SELECT l.name, COUNT(f.film_id) FROM film f 
INNER JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

--cambiar idioma de algunas peliculas
UPDATE film SET language_id = 2 WHERE film_id > 100 and film_id < 200;
UPDATE film SET language_id = 3 WHERE film_id > 200 and film_id < 300;
UPDATE film SET language_id = 4 WHERE film_id > 300 and film_id < 400;

SELECT title FROM film
WHERE language_id IN (SELECT language_id FROM language WHERE name = 'English');

--peliculas mas alquiladas:
SELECT * FROM film f 
INNER JOIN  (SELECT * FROM inventory i 
INNER JOIN rental r ON r.inventory_id = i.inventory_id) res ON res.film_id = f.film_id;

-- count ventas por empleado:
SELECT e.name, COUNT(s.id) FROM sale s
INNER JOIN employee e ON s.id_employee = e.id;
GROUP BY e.name

-----------------------------------------------------------------------------------------------

-- Consultas de utilizad para explorar y administrat bases de datos y tablas

-- Ver tamaño de bases de datos:
SELECT pg_database.datname, pg_size_pretty (pg_database_size(pg_database.datname)) as size FROM pg_database;

SELECT pg_size_pretty (pg_database_size('pagila'))

-- Ver tamaño de las tablas:
SELECT pg_size_pretty(pg_relation_size('orders'))

-- Consultas joints: 
SELECT o.id, c.contact_name FROM orders o 
INNER JOIN customers ON o.customers_id = c.customers_id;

-- GROUP BY:
SELECT city, COUNT(customer_id) AS num_customers FROM customers GROUP BY city;

--Vistas: Son una forma de guardar las consultas SQL bajo un identificador para ejecutar
-- consultas de manera más rápida.
CREATE VIEW num_orders_by_employee

-- Vistas Materializadas: guardan fisicamente el resultado de una query y actualizan
-- los datos periodicamente. Guardan en caché.
CREATE MATERIALIZED VIEW IF NOT EXISTS view_name AS
query
WITH [NO] DATA;

-- Generate Series: Integrar datos ficticios en tabla
CREATE TABLE example(
	id INT,
	name VARCHAR
)

INSERT INTO example(id)
SELECT * FROM GENERATE_SERIES(1, 500000)

SELECT * FROM GENERATE_SERIES(
	'2022-01-01 00:00' :: timestamp;
	'2022-12-25 00:00',
	'6 hours'
)

-- Explain Analize: permite mostrar el query planner y ver los tiempos
EXPLAIN ANALYZE SELECT * FROM order_details;
CREATE INDEX idx_order_details_unit_price ON order_details(unit_price) WHERE unit_price < 10;

EXPLAIN ANALYZE SELECT * FROM num_orders_by_employee;
EXPLAIN ANALYZE SELECT * FROM orders;

-- Indices: se usan para optimizar tiempos de consultas cuando las tablas contienen muchos datos.
CREATE INDEX idx_orders_pk ON orders(order_id);
EXPLAIN ANALYZE SELECT * FROM orders;

SELECT * FROM example;
EXPLAIN ANALYZE SELECT * FROM example;
CREATE INDEX idx_orders_pk ON orders(order_id);

EXPLAIN ANALYZE SELECT * FROM example WHERE id = 456777;

-- Particionamiento de tablas: Tecnica que permite dividir una misma tabla en múltiples particiones,
-- con el objetivo de optimizar las consultas.

-- Hay 3 tipos:
-- Rango
-- Lista
-- Hash

CREATE TABLE users(
	id BIGSERIAL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	PRIMARY KEY(id, birth_date)
) PARTITION BY RANGE (birth_date);

CREATE TABLE users_2020 PARTITION OF users
FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE users_2020 PARTITION OF users
FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE users_2020 PARTITION OF users
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

INSERT INTO users(birth_date, first_name) VALUES
	('2020-01-15', 'user 1'),
	('2020-06-15', 'user 2'),
	('2021-02-15', 'user 3'),
	('2021-11-15', 'user 4'),
	('2022-04-15', 'user 5'),
	('2022-12-15', 'user 6');

SELECT * FROM users_2020;
SELECT * FROM users_2021;
SELECT * FROM users_2022;

EXPLAIN ANALYZE SELECT * FROM users; 
EXPLAIN ANALYZE SELECT * FROM users WHERE birth_date = '2020-06-15';
EXPLAIN ANALYZE SELECT * FROM users WHERE birth_date = '2021-02-15';
EXPLAIN ANALYZE SELECT * FROM users WHERE birth_date > '2021-02-14' AND birth_date < '2022-12-16';







