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
-- Name: schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedules_id_seq', 55, true);


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE schedules DISABLE TRIGGER ALL;

COPY schedules (id, name, description, effective_date, ineffective_date, parent_id, repeats_every, repeats_on, lft, rgt) FROM stdin;
50	A	Week A	2008-01-28	2008-01-28	1	2	0	2	3
51	B	Week B	2008-01-28	2008-01-29	1	2	1	4	5
1	main	Main Schedule	2005-01-01	2016-12-31	\N	1	0	1	6
\.


ALTER TABLE schedules ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

