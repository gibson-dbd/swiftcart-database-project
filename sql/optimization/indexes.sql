SELECT *
FROM customers
WHERE email = 'john.doe@email.com';


CREATE INDEX idx_customers_email
ON customers(email);


SELECT *
FROM pg_indexes
WHERE tablename = 'customers';


CREATE INDEX idx_products_name
ON products(product_name);


CREATE INDEX idx_orders_customer
ON orders(customer_id);


CREATE INDEX idx_orderitems_order
ON order_items(order_id);


CREATE INDEX idx_orderitems_product
ON order_items(product_id);



SELECT *
FROM orders
WHERE customer_id = 1;


SELECT *
FROM orders
WHERE customer_id = 1
AND status = 'Paid';


CREATE INDEX idx_orders_customer_status
ON orders(customer_id, status);


EXPLAIN
SELECT *
FROM customers
WHERE email = 'john.doe@email.com';


EXPLAIN ANALYZE

SELECT *
FROM customers
WHERE email = 'john.doe@email.com';




SELECT
    c.first_name,
    c.last_name,
    o.order_id,
    o.total_amount
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id;



SELECT *
FROM pg_indexes
WHERE tablename='customers';