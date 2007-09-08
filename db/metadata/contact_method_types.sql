--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: contact_method_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('contact_method_types', 'id'), 15, true);


--
-- Data for Name: contact_method_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE contact_method_types DISABLE TRIGGER ALL;

COPY contact_method_types (id, description, parent_id, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
1	phone	\N	0	2006-09-20 07:38:21	2006-09-20 07:38:21	1	1
5	email	\N	0	2006-09-20 07:39:55	2006-09-20 07:39:55	1	1
8	fax	\N	0	2006-09-20 07:40:14	2006-09-20 07:40:14	1	1
2	home phone	1	1	2006-09-21 08:31:45	2006-09-20 07:38:40	1	1
3	work phone	1	1	2006-09-21 08:37:15	2006-09-20 07:38:55	1	1
6	home email	5	1	2006-09-21 08:40:22	2006-09-20 07:40:03	1	1
13	liason	\N	0	2006-11-25 02:31:31	2006-11-25 02:31:31	1	1
14	emergency phone	1	0	2006-12-05 18:03:37	2006-12-05 18:03:37	1	1
4	cell phone	1	1	2006-12-05 18:03:51	2006-09-20 07:39:43	1	1
7	work email	5	1	2006-12-05 18:04:01	2006-09-20 07:40:07	1	1
9	home fax	8	1	2006-12-05 18:04:11	2006-09-20 07:40:22	1	1
10	work fax	8	1	2006-12-05 18:04:19	2006-09-20 07:40:25	1	1
15	ip phone	1	0	2007-07-11 16:29:24	2007-07-11 16:29:24	1	1
\.


ALTER TABLE contact_method_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

