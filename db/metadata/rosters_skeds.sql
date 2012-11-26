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
-- Data for Name: rosters_skeds; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE rosters_skeds DISABLE TRIGGER ALL;

COPY rosters_skeds (sked_id, roster_id, "position") FROM stdin;
2	6	0
2	7	1
2	8	2
2	9	3
2	10	4
2	19	5
4	14	3
3	5	2
3	4	1
3	15	0
4	12	2
4	11	1
4	13	0
4	23	\N
4	25	\N
4	26	\N
2	28	\N
2	29	\N
5	6	0
5	9	1
5	10	2
5	29	3
6	16	0
6	17	1
6	18	2
7	26	0
7	13	1
8	23	0
8	12	1
\.


ALTER TABLE rosters_skeds ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

