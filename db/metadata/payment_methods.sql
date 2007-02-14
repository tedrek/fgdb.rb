--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fgdb
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('payment_methods', 'id'), 5, true);


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: fgdb
--

ALTER TABLE payment_methods DISABLE TRIGGER ALL;

COPY payment_methods (id, description, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
1	cash	0	2006-09-25 13:12:18-07	2006-09-25 13:12:18-07	1	1
2	check	0	2006-09-25 13:12:23-07	2006-09-25 13:12:23-07	1	1
3	credit	0	2006-11-21 13:41:18-08	2006-11-21 13:41:18-08	1	1
5	invoice	0	2007-01-31 21:16:39-08	2007-01-31 21:16:39-08	1	1
\.


ALTER TABLE payment_methods ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

