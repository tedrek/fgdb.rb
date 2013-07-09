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
-- Data for Name: income_streams; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE income_streams DISABLE TRIGGER ALL;

COPY income_streams (id, name, description, created_at, updated_at) FROM stdin;
13	desktops	Desktop Build	2012-03-20 11:18:59.12519	2012-03-20 11:18:59.12519
14	macintoshes	Macintosh Build	2012-03-20 11:19:15.596639	2012-03-20 11:19:15.596639
15	printers	Printerland	2012-03-20 11:19:54.409181	2012-03-20 11:19:54.409181
16	servers	Server Build	2012-03-20 11:20:09.36117	2012-03-20 11:20:09.36117
17	testing	Advanced Testing	2012-03-20 11:20:25.149177	2012-03-20 11:20:25.149177
18	online	Online Sales	2012-03-20 11:20:58.873192	2012-03-20 11:20:58.873192
19	recycling	Receiving, Prebuild, Recycling	2012-03-20 11:21:19.297211	2012-03-20 11:21:19.297211
20	contributions	Front Desk Contributions	2012-03-20 11:21:40.001187	2012-03-20 11:21:40.001187
21	other	Miscellaneous	2012-03-20 11:22:02.613196	2012-03-20 11:22:02.613196
22	laptops	Laptop Build	2012-03-20 11:26:49.041229	2012-03-20 11:26:49.041229
23	n/a	Not Applicable	2012-03-27 13:16:55.621155	2012-03-27 13:16:55.621155
\.


ALTER TABLE income_streams ENABLE TRIGGER ALL;

--
-- Name: income_streams_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('income_streams_id_seq', 23, true);


--
-- PostgreSQL database dump complete
--

