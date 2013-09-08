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
-- Data for Name: sked_members; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE sked_members DISABLE TRIGGER ALL;

COPY sked_members (id, sked_id, roster_id, "position") FROM stdin;
4	2	9	3
5	2	10	4
6	2	19	5
7	4	14	3
10	3	15	0
13	4	13	0
19	5	6	0
22	5	29	3
23	6	16	0
26	7	26	0
28	8	23	0
2	2	7	0
9	3	4	0
12	4	11	0
14	4	23	0
15	4	25	0
16	4	26	0
18	2	29	0
20	5	9	0
24	6	17	0
27	7	13	0
29	8	12	0
1	2	6	0
17	2	28	1
3	2	8	1
8	3	5	1
11	4	12	1
21	5	10	1
25	6	18	1
\.


ALTER TABLE sked_members ENABLE TRIGGER ALL;

--
-- Name: sked_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('sked_members_id_seq', 30, true);


--
-- PostgreSQL database dump complete
--

