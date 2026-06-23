#### Customer places an order.
System should create order automatically.





CREATE OR REPLACE PROCEDURE create_order(

    p_customer_id INT,

    p_total_amount NUMERIC,

    p_status VARCHAR

)

LANGUAGE plpgsql

AS
$$

BEGIN

    INSERT INTO orders
    (
        customer_id,
        total_amount,
        status
    )
    VALUES
    (
        p_customer_id,
        p_total_amount,
        p_status
    );

END;

$$;