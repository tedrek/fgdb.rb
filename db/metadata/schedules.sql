--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE schedules DISABLE TRIGGER ALL;

COPY schedules (id, name, description, effective_date, ineffective_date, repeats_every, repeats_on, generate_from, reference_from) FROM stdin;
50	A	Week A	2008-01-28	2008-01-28	2	0	f	f
51	B	Week B	2008-01-28	2008-01-29	2	1	f	f
1	main	Main Schedule	2005-01-01	2016-12-31	1	0	t	f
\.


ALTER TABLE schedules ENABLE TRIGGER ALL;

--
-- Name: schedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('schedules_id_seq', 55, true);


--
-- PostgreSQL database dump complete
--

