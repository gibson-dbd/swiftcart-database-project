## Inventory is not updating automatically.

CREATE OR REPLACE FUNCTION update_inventory()

RETURNS TRIGGER AS
$$

BEGIN

    UPDATE products

    SET stock_quantity =
        stock_quantity - NEW.quantity

    WHERE product_id = NEW.product_id;

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;





CREATE TRIGGER trg_update_inventory

AFTER INSERT

ON order_items

FOR EACH ROW

EXECUTE FUNCTION update_inventory();


SELECT
product_name,
stock_quantity
FROM products
WHERE product_id = 1;




## Prevent Negative Inventory

CREATE OR REPLACE FUNCTION validate_inventory()

RETURNS TRIGGER AS
$$

DECLARE
    current_stock INT;

BEGIN

    SELECT stock_quantity

    INTO current_stock

    FROM products

    WHERE product_id = NEW.product_id;

    IF NEW.quantity > current_stock THEN

        RAISE EXCEPTION
        'Insufficient inventory';

    END IF;

    RETURN NEW;

END;

$$ LANGUAGE plpgsql;



CREATE TRIGGER trg_validate_inventory

BEFORE INSERT

ON order_items

FOR EACH ROW

EXECUTE FUNCTION validate_inventory();


INSERT INTO order_items
(
    order_id,
    product_id,
    quantity,
    unit_price
)
VALUES
(
    1,
    1,
    1000,
    450000
);