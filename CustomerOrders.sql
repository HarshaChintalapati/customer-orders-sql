-- Creating the customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255)
);

-- Inserting data into the customers table
INSERT INTO customers (customer_id, name, email) VALUES
(1, 'John Doe', 'john.doe@example.com'),
(2, 'Jane Smith', 'jane.smith@example.com'),
(3, 'Alice Johnson', 'alice.johnson@example.com'),
(4, 'Bob Brown', 'bob.brown@example.com'),
(5, 'Carol Davis', 'carol.davis@example.com'),
(6, 'David Wilson', 'david.wilson@example.com'),
(7, 'Emily Clark', 'emily.clark@example.com'),
(8, 'Frank Harris', 'frank.harris@example.com'),
(9, 'Grace Lewis', 'grace.lewis@example.com'),
(10, 'Hannah Walker', 'hannah.walker@example.com');

-- Creating the orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

-- Inserting data into the orders table
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-08-01', 250.00),
(2, 2, '2024-08-02', 150.50),
(3, 3, '2024-08-03', 99.99),
(4, 4, '2024-08-04', 299.90),
(5, 5, '2024-08-05', 189.75),
(6, 6, '2024-08-06', 349.20),
(7, 7, '2024-08-07', 129.45),
(8, 8, '2024-08-08', 89.99),
(9, 9, '2024-08-09', 499.99),
(10, 10, '2024-08-10', 75.00),
(11, 1, '2024-08-11', 400.50),
(12, 2, '2024-08-12', 220.00),
(13, 3, '2024-08-13', 105.25),
(14, 4, '2024-08-14', 215.30),
(15, 5, '2024-08-15', 310.00);

-- Creating the products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10, 2)
);

-- Inserting data into the products table
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Laptop', 999.99),
(2, 'Smartphone', 499.99),
(3, 'Headphones', 89.99),
(4, 'Keyboard', 45.99),
(5, 'Mouse', 25.99),
(6, 'Monitor', 199.99),
(7, 'Printer', 129.99),
(8, 'Tablet', 349.99),
(9, 'Webcam', 59.99),
(10, 'External Hard Drive', 129.99);

-- Creating the order_items table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER
);

-- Inserting data into the order_items table
INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES
(1, 1, 1, 1), 
(2, 1, 3, 2),
(3, 2, 2, 1), 
(4, 2, 5, 1), 
(5, 3, 4, 1), 
(6, 4, 6, 2),
(7, 5, 7, 1), 
(8, 6, 8, 1), 
(9, 7, 9, 1), 
(10, 8, 3, 1),
(11, 9, 10, 1), 
(12, 10, 2, 1), 
(13, 11, 1, 1), 
(14, 12, 6, 1), 
(15, 13, 4, 1), 
(16, 14, 8, 1),
(17, 15, 5, 2); 

-- Creating the categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255)
);

-- Inserting data into the categories table
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Electronics'),
(2, 'Accessories'),
(3, 'Computers'),
(4, 'Office Supplies'),
(5, 'Mobile Devices');

-- 1.Retrieve All Order details for a Specific Customer
SELECT customers.customer_id, customers.name,orders.order_date,orders.order_id,orders.total_amount
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
WHERE customers.customer_id = '3';
--Add category_id in products table and establish relationship
alter table products add category_id int;
alter table products add foreign key(category_id) references categories(category_id);
UPDATE products
SET category_id = CASE 
    WHEN product_id = 1 THEN 1
    WHEN product_id = 2 THEN 2
    WHEN product_id = 3 THEN 3
    WHEN product_id = 4 THEN 4
    WHEN product_id = 5 THEN 5
    WHEN product_id = 6 THEN 1
    WHEN product_id = 7 THEN 2
    WHEN product_id = 8 THEN 3
    WHEN product_id = 9 THEN 4
    WHEN product_id = 10 THEN 5
    ELSE price
END
WHERE product_id IN (1,2,3,4,5,6,7,8,9,10);

--2.List All Products with Their Categories
SELECT products.product_id, products.product_name, categories.category_name
FROM products
INNER JOIN categories ON products.category_id = categories.category_id;

--3.Retrieve Order Items and Their Product Details for a Specific Order
SELECT orders.order_id, order_items.product_id, products.product_name, order_items.quantity
FROM orders
INNER JOIN order_items ON orders.order_id = order_items.order_id
INNER JOIN products ON order_items.product_id = products.product_id
WHERE orders.order_id = '3';

--4.Find Customers Who Have Placed Orders Above a Certain Amount
SELECT customers.customer_id, customers.name
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
HAVING SUM(orders.total_amount) > 200;

--5.Get the Total Number of Orders and Total Amount Spent by Each Customer
SELECT customers.customer_id, customers.name, COUNT(orders.order_id) AS total_orders, SUM(orders.total_amount) AS total_spent
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name;

--6.List Products and Their Total Sales Amount
SELECT products.product_id, products.product_name, SUM(order_items.quantity * products.price) AS total_sales_amount
FROM products
INNER JOIN order_items ON products.product_id = order_items.product_id
GROUP BY products.product_id, products.product_name;

--7.Update Product Prices Based on a Percentage Increase(10%)
UPDATE products
SET price = price * (1 + 10/ 100);

--8.Add a New Column to Track Product Stock Quantity
ALTER TABLE products
ADD COLUMN stock_quantity INT;

UPDATE products
SET stock_quantity = CASE 
    WHEN product_id = 1 THEN 1
    WHEN product_id = 2 THEN 2
    WHEN product_id = 3 THEN 3
    WHEN product_id = 4 THEN 4
    WHEN product_id = 5 THEN 5
    WHEN product_id = 6 THEN 1
    WHEN product_id = 7 THEN 2
    WHEN product_id = 8 THEN 3
    WHEN product_id = 9 THEN 4
    WHEN product_id = 10 THEN 5
    ELSE price
end

--9.. Retrieve Customers Who Have Placed More Than 5 Orders
SELECT customers.customer_id, customers.name, COUNT(orders.order_id) AS total_orders
FROM customers
INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.name
HAVING COUNT(orders.order_id) > 1;

--10.Retrieve the Most Expensive Product in Each Category
SELECT c.category_name, p.product_name, MAX(p.price) as max_price
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name, p.product_name
ORDER BY max_price DESC;











  


