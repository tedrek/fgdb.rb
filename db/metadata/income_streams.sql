--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: income_streams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('income_streams_id_seq', 12, true);


--
-- Data for Name: income_streams; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE income_streams DISABLE TRIGGER ALL;

COPY income_streams (id, name, description, created_at, updated_at) FROM stdin;
3	sales	Sales	2009-11-24 17:07:00.20429	2009-11-24 17:07:00.20429
4	vets	Volunteer Ed & Tech Support	2009-11-24 17:07:00.208291	2009-11-24 17:07:00.208291
5	reuse	Reuse	2009-11-24 17:07:00.208291	2009-11-24 17:07:00.208291
2	r-and-r	Receiving & Recycling	2009-11-24 17:07:00.20429	2009-11-24 17:07:00.20429
1	admin	Administrative Services	2009-11-24 17:07:00.12028	2009-11-24 17:07:00.12028
6	outreach	Outreach & Development	2009-11-24 17:07:00.208291	2009-11-24 17:07:00.208291
12	mixed	Mixed	2011-08-27 01:45:13.905394	2011-08-27 01:45:13.905394
\.


ALTER TABLE income_streams ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

