--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE payment_methods DISABLE TRIGGER ALL;

COPY payment_methods (id, description, lock_version, updated_at, created_at, name) FROM stdin;
6	coupon	0	2007-12-11 17:43:33	2007-12-11 17:43:33	coupon
5	invoice	0	2007-01-31 21:16:39	2007-01-31 21:16:39	invoice
3	credit	0	2006-11-21 13:41:18	2006-11-21 13:41:18	credit
1	cash	0	2006-09-25 13:12:18	2006-09-25 13:12:18	cash
2	check	0	2006-09-25 13:12:23	2006-09-25 13:12:23	check
7	store credit	0	2009-08-12 01:46:01.155962	2009-08-12 01:46:01.155962	store_credit
8	online	0	2010-11-06 00:52:32.946189	2010-11-06 00:52:32.946189	online
11	written off invoice	0	2011-04-08 19:45:20.896898	2011-04-08 19:45:20.896898	written_off_invoice
\.


ALTER TABLE payment_methods ENABLE TRIGGER ALL;

--
-- Name: payment_methods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('payment_methods_id_seq', 11, true);


--
-- PostgreSQL database dump complete
--

