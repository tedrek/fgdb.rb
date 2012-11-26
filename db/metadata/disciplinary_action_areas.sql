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
-- Name: disciplinary_action_areas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('disciplinary_action_areas_id_seq', 13, true);


--
-- Data for Name: disciplinary_action_areas; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE disciplinary_action_areas DISABLE TRIGGER ALL;

COPY disciplinary_action_areas (id, name, created_at, updated_at) FROM stdin;
1	All Areas	2012-04-14 09:21:00.823222	2012-04-14 09:21:00.823222
2	Advanced Testing	2012-04-14 09:21:00.846988	2012-04-14 09:21:00.846988
3	Prebuild	2012-04-14 09:21:00.851462	2012-04-14 09:21:00.851462
4	Build	2012-04-14 09:21:00.855628	2012-04-14 09:21:00.855628
5	Server Build	2012-04-14 09:21:00.859806	2012-04-14 09:21:00.859806
6	Mac Build	2012-04-14 09:21:00.863959	2012-04-14 09:21:00.863959
7	Laptops	2012-04-14 09:21:00.868072	2012-04-14 09:21:00.868072
8	Receiving	2012-04-14 09:21:00.872206	2012-04-14 09:21:00.872206
9	Recycling	2012-04-14 09:21:00.876317	2012-04-14 09:21:00.876317
10	Printerland	2012-04-14 09:21:00.880439	2012-04-14 09:21:00.880439
11	Other (see notes)	2012-04-14 09:21:00.884539	2012-04-14 09:21:00.884539
12	Adoption Classes	2012-04-14 13:08:51.765148	2012-04-14 13:08:51.765148
13	Classes	2012-04-14 13:08:51.813514	2012-04-14 13:08:51.813514
\.


ALTER TABLE disciplinary_action_areas ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

