--
-- PostgreSQL database dump
--

\restrict scPLTeC9YanbicE2fXYkWDpcLAtoHKygwHZowKDckkyhPgkIOxUpNSEdmJgThdh

-- Dumped from database version 18.4 (Homebrew)
-- Dumped by pg_dump version 18.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: create_order(integer, numeric, character varying); Type: PROCEDURE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE PROCEDURE public.create_order(IN p_customer_id integer, IN p_total_amount numeric, IN p_status character varying)
    LANGUAGE plpgsql
    AS $$

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


ALTER PROCEDURE public.create_order(IN p_customer_id integer, IN p_total_amount numeric, IN p_status character varying) OWNER TO gibsonnwagboniwe;

--
-- Name: get_customer_total_spent(integer); Type: FUNCTION; Schema: public; Owner: gibsonnwagboniwe
--

CREATE FUNCTION public.get_customer_total_spent(p_customer_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$

DECLARE
    total_spent NUMERIC;

BEGIN

    SELECT COALESCE(SUM(total_amount),0)
    INTO total_spent
    FROM orders
    WHERE customer_id = p_customer_id;

    RETURN total_spent;

END;

$$;


ALTER FUNCTION public.get_customer_total_spent(p_customer_id integer) OWNER TO gibsonnwagboniwe;

--
-- Name: update_inventory(); Type: FUNCTION; Schema: public; Owner: gibsonnwagboniwe
--

CREATE FUNCTION public.update_inventory() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

BEGIN

    UPDATE products

    SET stock_quantity =
        stock_quantity - NEW.quantity

    WHERE product_id = NEW.product_id;

    RETURN NEW;

END;

$$;


ALTER FUNCTION public.update_inventory() OWNER TO gibsonnwagboniwe;

--
-- Name: validate_inventory(); Type: FUNCTION; Schema: public; Owner: gibsonnwagboniwe
--

CREATE FUNCTION public.validate_inventory() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.validate_inventory() OWNER TO gibsonnwagboniwe;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    category_name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.categories OWNER TO gibsonnwagboniwe;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO gibsonnwagboniwe;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gibsonnwagboniwe
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.customers OWNER TO gibsonnwagboniwe;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO gibsonnwagboniwe;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gibsonnwagboniwe
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price > (0)::numeric))
);


ALTER TABLE public.order_items OWNER TO gibsonnwagboniwe;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE SEQUENCE public.order_items_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_order_item_id_seq OWNER TO gibsonnwagboniwe;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gibsonnwagboniwe
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    customer_id integer NOT NULL,
    order_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    total_amount numeric(12,2),
    status character varying(20),
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['Pending'::character varying, 'Paid'::character varying, 'Shipped'::character varying, 'Delivered'::character varying, 'Cancelled'::character varying])::text[]))),
    CONSTRAINT orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public.orders OWNER TO gibsonnwagboniwe;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO gibsonnwagboniwe;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gibsonnwagboniwe
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    product_name character varying(150) NOT NULL,
    category_id integer NOT NULL,
    price numeric(10,2) NOT NULL,
    stock_quantity integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric)),
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= 0))
);


ALTER TABLE public.products OWNER TO gibsonnwagboniwe;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: gibsonnwagboniwe
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO gibsonnwagboniwe;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gibsonnwagboniwe
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: gibsonnwagboniwe
--

COPY public.categories (category_id, category_name, description) FROM stdin;
1	Electronics	Electronic gadgets and accessories
2	Fashion	Clothing and fashion items
3	Home Appliances	Household appliances
4	Books	Educational and entertainment books
5	Sports	Sports equipment and accessories
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: gibsonnwagboniwe
--

COPY public.customers (customer_id, first_name, last_name, email, phone, created_at) FROM stdin;
1	John	Doe	john.doe@email.com	08012345678	2026-06-21 22:38:46.844502
2	Mary	Johnson	mary.johnson@email.com	08023456789	2026-06-21 22:38:46.844502
3	David	Brown	david.brown@email.com	08034567890	2026-06-21 22:38:46.844502
4	Sarah	Wilson	sarah.wilson@email.com	08045678901	2026-06-21 22:38:46.844502
5	Michael	Davis	michael.davis@email.com	08056789012	2026-06-21 22:38:46.844502
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: gibsonnwagboniwe
--

COPY public.order_items (order_item_id, order_id, product_id, quantity, unit_price) FROM stdin;
1	1	1	1	450000.00
2	2	3	1	75000.00
3	3	4	1	120000.00
4	1	1	2	450000.00
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: gibsonnwagboniwe
--

COPY public.orders (order_id, customer_id, order_date, total_amount, status) FROM stdin;
1	1	2026-06-21 22:38:46.844502	450000.00	Paid
2	2	2026-06-21 22:38:46.844502	75000.00	Pending
3	3	2026-06-21 22:38:46.844502	120000.00	Delivered
4	1	2026-06-23 06:32:19.365018	250000.00	Paid
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: gibsonnwagboniwe
--

COPY public.products (product_id, product_name, category_id, price, stock_quantity, created_at) FROM stdin;
2	Samsung Galaxy A55	1	350000.00	35	2026-06-21 22:38:46.844502
3	Nike Running Shoes	2	75000.00	50	2026-06-21 22:38:46.844502
4	Air Fryer	3	120000.00	15	2026-06-21 22:38:46.844502
5	Database Design Fundamentals	4	15000.00	100	2026-06-21 22:38:46.844502
6	Football	5	12000.00	40	2026-06-21 22:38:46.844502
1	HP Laptop	1	450000.00	18	2026-06-21 22:38:46.844502
\.


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gibsonnwagboniwe
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 5, true);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gibsonnwagboniwe
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 5, true);


--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gibsonnwagboniwe
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 5, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gibsonnwagboniwe
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 4, true);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: gibsonnwagboniwe
--

SELECT pg_catalog.setval('public.products_product_id_seq', 6, true);


--
-- Name: categories categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_category_name_key UNIQUE (category_name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: idx_customers_email; Type: INDEX; Schema: public; Owner: gibsonnwagboniwe
--

CREATE INDEX idx_customers_email ON public.customers USING btree (email);


--
-- Name: idx_orderitems_order; Type: INDEX; Schema: public; Owner: gibsonnwagboniwe
--

CREATE INDEX idx_orderitems_order ON public.order_items USING btree (order_id);


--
-- Name: idx_orderitems_product; Type: INDEX; Schema: public; Owner: gibsonnwagboniwe
--

CREATE INDEX idx_orderitems_product ON public.order_items USING btree (product_id);


--
-- Name: idx_orders_customer; Type: INDEX; Schema: public; Owner: gibsonnwagboniwe
--

CREATE INDEX idx_orders_customer ON public.orders USING btree (customer_id);


--
-- Name: idx_orders_customer_status; Type: INDEX; Schema: public; Owner: gibsonnwagboniwe
--

CREATE INDEX idx_orders_customer_status ON public.orders USING btree (customer_id, status);


--
-- Name: idx_products_name; Type: INDEX; Schema: public; Owner: gibsonnwagboniwe
--

CREATE INDEX idx_products_name ON public.products USING btree (product_name);


--
-- Name: order_items trg_update_inventory; Type: TRIGGER; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TRIGGER trg_update_inventory AFTER INSERT ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.update_inventory();


--
-- Name: order_items trg_validate_inventory; Type: TRIGGER; Schema: public; Owner: gibsonnwagboniwe
--

CREATE TRIGGER trg_validate_inventory BEFORE INSERT ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.validate_inventory();


--
-- Name: orders fk_order_customer; Type: FK CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: order_items fk_orderitem_order; Type: FK CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_orderitem_order FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: order_items fk_orderitem_product; Type: FK CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_orderitem_product FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: products fk_product_category; Type: FK CONSTRAINT; Schema: public; Owner: gibsonnwagboniwe
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: gibsonnwagboniwe
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.categories TO app_developer;
GRANT SELECT ON TABLE public.categories TO business_analyst;
GRANT SELECT ON TABLE public.categories TO read_only_user;
GRANT ALL ON TABLE public.categories TO db_admin;


--
-- Name: TABLE customers; Type: ACL; Schema: public; Owner: gibsonnwagboniwe
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.customers TO app_developer;
GRANT SELECT ON TABLE public.customers TO business_analyst;
GRANT SELECT ON TABLE public.customers TO read_only_user;
GRANT ALL ON TABLE public.customers TO db_admin;


--
-- Name: TABLE order_items; Type: ACL; Schema: public; Owner: gibsonnwagboniwe
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.order_items TO app_developer;
GRANT SELECT ON TABLE public.order_items TO business_analyst;
GRANT SELECT ON TABLE public.order_items TO read_only_user;
GRANT ALL ON TABLE public.order_items TO db_admin;


--
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: gibsonnwagboniwe
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.orders TO app_developer;
GRANT SELECT ON TABLE public.orders TO business_analyst;
GRANT SELECT ON TABLE public.orders TO read_only_user;
GRANT ALL ON TABLE public.orders TO db_admin;


--
-- Name: TABLE products; Type: ACL; Schema: public; Owner: gibsonnwagboniwe
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.products TO app_developer;
GRANT SELECT ON TABLE public.products TO business_analyst;
GRANT SELECT ON TABLE public.products TO read_only_user;
GRANT ALL ON TABLE public.products TO db_admin;


--
-- PostgreSQL database dump complete
--

\unrestrict scPLTeC9YanbicE2fXYkWDpcLAtoHKygwHZowKDckkyhPgkIOxUpNSEdmJgThdh

