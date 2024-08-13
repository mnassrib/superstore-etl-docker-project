-- Créer la base de données
CREATE DATABASE IF NOT EXISTS superstore;

-- Utiliser la base de données
USE superstore;

-- Supprimer les tables existantes
DROP TABLE IF EXISTS temp_superstore;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS sales_reps;
DROP TABLE IF EXISTS locations;

-- Créer la table customers
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);

-- Créer la table products
CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(150),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

-- Créer la table sales_reps
CREATE TABLE IF NOT EXISTS sales_reps (
    sales_rep VARCHAR(100) PRIMARY KEY,
    sales_team VARCHAR(50),
    sales_team_manager VARCHAR(50)
);

-- Créer la table locations
CREATE TABLE IF NOT EXISTS locations (
    location_id VARCHAR(50) PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50)
);

-- Créer la table orders
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50)
);

-- Créer la table order_details
CREATE TABLE IF NOT EXISTS order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    customer_id VARCHAR(50),
    sales_rep VARCHAR(100),
    location_id VARCHAR(50),
    sales DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (sales_rep) REFERENCES sales_reps(sales_rep),
    FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Créer une table temporaire pour charger les données CSV
CREATE TABLE IF NOT EXISTS temp_superstore (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    sales_rep VARCHAR(100),
    location_id VARCHAR(50),
    product_id VARCHAR(50),
    sales DECIMAL(10, 2),
    quantity INT,
    discount DECIMAL(10, 2),
    profit DECIMAL(10, 2),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    product_name VARCHAR(150),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    sales_team VARCHAR(50),
    sales_team_manager VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50)
);

-- Charger les données CSV dans la table temporaire
LOAD DATA INFILE '/var/lib/mysql_files/CleanedSuperStoreData.csv'
INTO TABLE temp_superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Insérer les données dans la table customers
INSERT INTO customers (customer_id, customer_name, segment)
SELECT DISTINCT customer_id, customer_name, segment
FROM temp_superstore;

-- Insérer les données dans la table products
INSERT INTO products (product_id, product_name, category, sub_category)
SELECT DISTINCT product_id, product_name, category, sub_category
FROM temp_superstore;

-- Insérer les données dans la table sales_reps
INSERT INTO sales_reps (sales_rep, sales_team, sales_team_manager)
SELECT DISTINCT sales_rep, sales_team, sales_team_manager
FROM temp_superstore;

-- Insérer les données dans la table locations
INSERT INTO locations (location_id, city, state, postal_code, region)
SELECT DISTINCT location_id, city, state, postal_code, region
FROM temp_superstore;

-- Insérer les données dans la table orders
INSERT INTO orders (order_id, order_date, ship_date, ship_mode)
SELECT DISTINCT order_id, order_date, ship_date, ship_mode
FROM temp_superstore;

-- Insérer les données dans la table order_details
INSERT INTO order_details (order_id, product_id, customer_id, sales_rep, location_id, sales, quantity, discount, profit)
SELECT t.order_id, t.product_id, t.customer_id, t.sales_rep, t.location_id, t.sales, t.quantity, t.discount, t.profit
FROM temp_superstore t
JOIN orders o ON t.order_id = o.order_id;

-- Supprimer la table temporaire
DROP TABLE IF EXISTS temp_superstore;
