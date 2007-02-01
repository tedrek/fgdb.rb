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

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('gizmo_typeattrs', 'id'), 21, true);


--
-- Data for Name: gizmo_typeattrs; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE gizmo_typeattrs DISABLE TRIGGER ALL;

COPY gizmo_typeattrs (id, gizmo_type_id, gizmo_attr_id, is_required, validation_callback, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
14	13	3	t		0	2006-11-11 19:33:27-08	2006-11-11 19:33:27-08	1	1
15	17	3	t		1	2006-11-11 19:40:35-08	2006-11-11 19:33:42-08	1	1
17	1	2	t		1	2006-12-20 09:56:18-08	2006-11-11 19:38:07-08	1	1
\.


ALTER TABLE gizmo_typeattrs ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

