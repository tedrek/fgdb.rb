--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: gizmo_attrs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('gizmo_attrs', 'id'), 9, true);


--
-- Data for Name: gizmo_attrs; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE gizmo_attrs DISABLE TRIGGER ALL;

COPY gizmo_attrs (id, name, datatype, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
1	suggested_price	monetary	1	2006-11-07 13:28:31-08	2006-10-10 12:10:04-07	1	1
2	size	integer	1	2006-11-07 13:28:37-08	2006-10-10 12:10:33-07	1	1
3	unit_price	monetary	1	2006-11-07 13:28:46-08	2006-10-18 18:04:44-07	1	1
8	presumed_functional	boolean	1	2006-11-07 13:29:15-08	2006-11-01 13:05:01-08	1	1
9	extended_price	monetary	0	2006-11-18 13:34:57-08	2006-11-18 13:34:57-08	1	1
\.


ALTER TABLE gizmo_attrs ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

