--
-- PostgreSQL database dump
--

\restrict d6ma6eRJouqbyetHJjhLTGLtimwOm5GV09JE1M4eMGZhtvNozl9S99DlEe9FgGE

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
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: gibsonnwagboniwe
--

COPY public.order_items (order_item_id, order_id, product_id, quantity, unit_price) FROM stdin;
1	1	1	1	450000.00
2	2	3	1	75000.00
3	3	4	1	120000.00
4	1	1	2	450000.00
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
-- PostgreSQL database dump complete
--

\unrestrict d6ma6eRJouqbyetHJjhLTGLtimwOm5GV09JE1M4eMGZhtvNozl9S99DlEe9FgGE

