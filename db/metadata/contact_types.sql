--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: contact_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('contact_types', 'id'), 11, true);


--
-- Data for Name: contact_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE contact_types DISABLE TRIGGER ALL;

COPY contact_types (id, description, for_who, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
7	donor	any	0	2006-09-20 07:45:14-07	2006-09-20 07:45:14-07	1	1
4	volunteer	per	1	2006-11-25 00:48:56-08	2006-09-20 07:44:25-07	1	1
5	nonprofit	org	2	2006-11-25 00:49:18-08	2006-09-20 07:44:41-07	1	1
3	staff	per	1	2006-11-25 00:49:27-08	2006-09-20 07:44:20-07	1	1
\.


ALTER TABLE contact_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

