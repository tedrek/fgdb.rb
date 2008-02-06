--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: gizmo_typeattrs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('gizmo_typeattrs', 'id'), 27, true);


--
-- Data for Name: gizmo_typeattrs; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE gizmo_typeattrs DISABLE TRIGGER ALL;

COPY gizmo_typeattrs (id, gizmo_type_id, gizmo_attr_id, is_required, validation_callback, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
14	13	3	t		0	2006-11-11 19:33:27	2006-11-11 19:33:27	1	1
15	17	3	t		1	2006-11-11 19:40:35	2006-11-11 19:33:42	1	1
17	1	2	t		1	2006-12-20 09:56:18	2006-11-11 19:38:07	1	1
22	19	10	t		0	2006-12-30 15:03:52	2006-12-30 15:03:52	1	1
23	20	10	t		0	2006-12-30 15:04:15	2006-12-30 15:04:15	1	1
24	21	10	t		0	2006-12-30 18:59:43	2006-12-30 18:59:43	1	1
26	38	10	t		0	2007-01-17 14:36:37	2007-01-17 14:36:37	1	1
27	13	10	t		2	2007-04-04 18:30:24	2007-01-24 16:30:53	1	1
25	31	10	t		2	2007-08-08 16:38:21	2007-01-02 10:35:40	1	1
\.


ALTER TABLE gizmo_typeattrs ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

