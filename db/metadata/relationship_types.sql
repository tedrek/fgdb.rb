--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: relationship_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fgdb
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('relationship_types', 'id'), 6, true);


--
-- Data for Name: relationship_types; Type: TABLE DATA; Schema: public; Owner: fgdb
--

ALTER TABLE relationship_types DISABLE TRIGGER ALL;

COPY relationship_types (id, description, direction_matters, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
5	works with	f	1	2006-09-22 08:10:01-07	2006-09-22 08:09:40-07	1	1
4	supervises	t	1	2006-09-22 08:11:15-07	2006-09-22 08:09:15-07	1	1
2	shares house with	f	3	2006-09-22 08:11:43-07	2006-09-20 07:57:30-07	1	1
6	works at	t	0	2006-09-22 08:14:12-07	2006-09-22 08:14:12-07	1	1
\.


ALTER TABLE relationship_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

