--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('types_id_seq', 10, true);


--
-- Data for Name: types; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE types DISABLE TRIGGER ALL;

COPY types (id, description, lock_version, updated_at, created_at, created_by, updated_by, name, gizmo_type_id) FROM stdin;
2	freekbox	0	2007-12-22 13:07:03.255511	2007-12-22 13:07:03.255511	1	1	freekbox	\N
9	miscellaneous	0	2007-12-22 13:07:03.299301	2007-12-22 13:07:03.299301	1	1	misc	\N
7	server	0	2007-12-22 13:07:03.287429	2007-12-22 13:07:03.287429	1	1	server	\N
6	infrastructure	0	2007-12-22 13:07:03.281438	2007-12-22 13:07:03.281438	1	1	infrastructure	\N
4	laptop	0	2007-12-22 13:07:03.269574	2007-12-22 13:07:03.269574	1	1	laptop	\N
3	grantbox	0	2007-12-22 13:07:03.263609	2007-12-22 13:07:03.263609	1	1	grantbox	\N
5	high end	0	2007-12-22 13:07:03.275499	2007-12-22 13:07:03.275499	1	1	high_end	\N
1	regular	0	2007-12-22 13:07:03.24582	2007-12-22 13:07:03.24582	1	1	regular	\N
8	apple	2	2012-12-08 05:39:55.572738	2007-12-22 13:07:03.293348	1	1	apple	\N
10	apple laptop	1	2012-12-08 05:39:55.578796	2010-02-19 23:43:54.054731	1	1	apple_laptop	\N
\.


ALTER TABLE types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

