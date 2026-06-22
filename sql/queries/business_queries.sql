Query 1: All Products

SELECT *
FROM products;


Query 2: Out of Stock Products

SELECT
product_id,
product_name,
stock_quantity
FROM products
WHERE stock_quantity = 0;


Query 3: Customers And Orders

SELECT
c.customer_id,
c.first_name,
c.last_name,
o.order_id,
o.status
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;


Query 4: Product Catalog

SELECT
p.product_name,
c.category_name,
p.price,
p.stock_quantity
FROM products p
JOIN categories c
ON p.category_id = c.category_id;