## which customers have placed orders?

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_orders DESC;



## How much revenue has been generated?

SELECT
    SUM(total_amount) AS total_revenue
FROM orders
WHERE status IN ('Paid', 'Delivered');




## How many products exist in each category?

SELECT
    c.category_name,
    COUNT(p.product_id) AS total_products
FROM categories c
LEFT JOIN products p
    ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY total_products DESC;


## Show current stock levels.

SELECT
    product_name,
    stock_quantity
FROM products
ORDER BY stock_quantity ASC;


## Which products are running low?

SELECT
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < 20
ORDER BY stock_quantity;


## This is the first professional report.

SELECT
    o.order_id,
    c.first_name,
    c.last_name,
    p.product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id;





## Top Selling Products

SELECT
    p.product_name,
    SUM(oi.quantity) AS total_units_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_units_sold DESC;





## How many orders are in each status?

SELECT
    status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY status;

## 