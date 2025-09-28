-- =========================================================
-- all_in_one.sql : Schema + Data Load (Windows-safe)
-- =========================================================

-- 1. Create database
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- 2. Users table
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(150),
  phone VARCHAR(20)
);

-- 3. Categories table
DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  name VARCHAR(100)
);

-- 4. Products table
DROP TABLE IF EXISTS products;
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(150),
  category_id INT,
  price DECIMAL(10,2),
  stock INT,
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 5. Orders table
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  user_id INT,
  order_date DATETIME,
  status VARCHAR(30),
  total_amount DECIMAL(12,2),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 6. Order Items table
DROP TABLE IF EXISTS order_items;
CREATE TABLE order_items (
  item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  qty INT,
  unit_price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================================================
-- Load CSV files into tables (Windows path + CRLF newlines)
-- =========================================================

LOAD DATA LOCAL INFILE 'C:/Users/MSAF/Downloads/users.csv'
INTO TABLE users
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/MSAF/Downloads/categories.csv'
INTO TABLE categories
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/MSAF/Downloads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/MSAF/Downloads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'C:/Users/MSAF/Downloads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SELECT * FROM users;
SELECT * FROM users WHERE phone IS NULL;
SELECT * FROM orders WHERE total_amount > 500;
SELECT * FROM orders WHERE order_date BETWEEN '2025-09-05' AND '2025-09-20';

-- =========================================================
-- 2. ORDER BY and LIMIT
-- =========================================================
SELECT * FROM orders ORDER BY order_date DESC LIMIT 5;
SELECT product_id, name, price FROM products ORDER BY price ASC LIMIT 5;

-- =========================================================
-- 3. Aggregations with GROUP BY and HAVING
-- =========================================================
SELECT user_id, COUNT(*) AS num_orders FROM orders GROUP BY user_id;

SELECT user_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY user_id
ORDER BY total_spent DESC;

SELECT user_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY user_id
HAVING SUM(total_amount) > 2000;

SELECT AVG(total_amount) AS avg_order_value FROM orders;

-- =========================================================
-- 4. Joins
-- =========================================================
-- Inner join: orders + users
SELECT o.order_id, u.name, o.total_amount, o.status
FROM orders o
INNER JOIN users u ON o.user_id = u.user_id;

-- Left join: all users + their orders
SELECT u.user_id, u.name, COUNT(o.order_id) AS total_orders
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

-- Right join: all orders + their users
SELECT o.order_id, o.total_amount, u.name
FROM orders o
RIGHT JOIN users u ON o.user_id = u.user_id;

-- Full outer join (simulate using UNION)
SELECT u.user_id, u.name, o.order_id, o.total_amount
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
UNION
SELECT u.user_id, u.name, o.order_id, o.total_amount
FROM users u
RIGHT JOIN orders o ON u.user_id = o.user_id;

-- Join orders + order_items + products + users
SELECT o.order_id, u.name AS customer, p.name AS product, oi.qty, oi.unit_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN users u ON o.user_id = u.user_id;

-- =========================================================
-- 5. Subqueries
-- =========================================================
-- Orders above average order value
SELECT * FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

-- Users who placed a high-value order
SELECT DISTINCT u.user_id, u.name
FROM users u
WHERE u.user_id IN (
  SELECT user_id FROM orders WHERE total_amount > 1000
);

-- Correlated subquery: orders above each user’s average
SELECT o1.*
FROM orders o1
WHERE o1.total_amount > (
  SELECT AVG(o2.total_amount)
  FROM orders o2
  WHERE o2.user_id = o1.user_id
);

-- =========================================================
-- 6. Views
-- =========================================================
CREATE OR REPLACE VIEW v_user_sales AS
SELECT u.user_id, u.name,
       COUNT(o.order_id) AS orders_count,
       SUM(o.total_amount) AS total_spent
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
GROUP BY u.user_id;

SELECT * FROM v_user_sales WHERE total_spent > 1000;

-- =========================================================
-- 7. Indexes and Query Optimization
-- =========================================================
CREATE INDEX idx_orders_user_date ON orders(user_id, order_date);

EXPLAIN SELECT * FROM orders
WHERE user_id = 1 AND order_date > '2025-09-10';

-- =========================================================
-- 8. NULL Handling
-- =========================================================
SELECT * FROM users WHERE phone IS NULL;
SELECT name, COALESCE(phone, 'NoPhone') AS phone_or_default
FROM users;

-- =========================================================
-- 9. Transactions (ACID demo)
-- =========================================================
START TRANSACTION;
UPDATE products SET stock = stock - 1 WHERE product_id = 1;
INSERT INTO orders (order_id, user_id, order_date, status, total_amount)
VALUES (999, 1, NOW(), 'placed', 499.00);
ROLLBACK;
