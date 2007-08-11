--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: disbursement_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('disbursement_types', 'id'), 5, true);


--
-- Data for Name: disbursement_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE disbursement_types DISABLE TRIGGER ALL;

COPY disbursement_types (id, description, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
1	Adoption	0	2007-04-04 17:26:09	2007-04-04 17:25:00	1	1
2	Build	0	2007-04-04 17:26:16	2007-04-04 17:26:00	1	1
3	Hardware Grants	0	2007-04-04 17:26:28	2007-04-04 17:26:00	1	1
4	GAP	0	2007-04-04 17:26:37	2007-04-04 17:26:00	1	1
5	Staff	0	2007-04-04 17:26:45	2007-04-04 17:26:00	1	1
\.


ALTER TABLE disbursement_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

