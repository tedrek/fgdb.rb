--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: dispersement_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('dispersement_types', 'id'), 1, false);


--
-- Data for Name: dispersement_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE dispersement_types DISABLE TRIGGER ALL;

COPY dispersement_types (id, description, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
\.


ALTER TABLE dispersement_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

