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
-- Name: skeds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('skeds_id_seq', 8, true);


--
-- Data for Name: skeds; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE skeds DISABLE TRIGGER ALL;

COPY skeds (id, name, created_at, updated_at, category_type) FROM stdin;
2	Build	2011-02-23 20:04:00.694401	2012-04-06 23:08:02.798884	Program
3	Prebuild	2011-02-23 20:04:11.402821	2012-04-06 23:08:02.84293	Area
4	Adoption	2011-02-23 20:04:23.025803	2012-04-06 23:08:02.851496	Program
5	Build Room	2011-11-02 16:48:47.642476	2012-04-06 23:08:02.855718	Area
6	Classes	2011-11-23 16:09:44.359651	2012-04-06 23:08:02.8637	Program
7	Printerland	2012-04-06 23:08:02.910501	2012-04-06 23:08:02.910501	Area
8	Recycling	2012-04-06 23:08:02.97697	2012-04-06 23:08:02.97697	Area
\.


ALTER TABLE skeds ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

