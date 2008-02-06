--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: discount_schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('discount_schedules', 'id'), 9, true);


--
-- Data for Name: discount_schedules; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE discount_schedules DISABLE TRIGGER ALL;

COPY discount_schedules (id, name, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
4	volunteer	0	2006-12-19 17:48:31	2006-12-19 17:48:31	1	1
8	bulk	0	2006-12-19 18:27:48	2006-12-19 18:27:48	1	1
5	friend	1	2006-12-20 08:31:02	2006-12-19 17:51:03	1	1
9	no discount	0	2006-12-20 08:31:27	2006-12-20 08:31:27	1	1
\.


ALTER TABLE discount_schedules ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

