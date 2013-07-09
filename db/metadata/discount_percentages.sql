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
-- Data for Name: discount_percentages; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE discount_percentages DISABLE TRIGGER ALL;

COPY discount_percentages (id, percentage, available, created_at, updated_at) FROM stdin;
1	0	t	2013-01-04 21:08:22.812883	2013-01-04 21:08:22.812883
2	5	f	2013-01-04 21:08:22.82308	2013-01-04 21:08:22.82308
3	10	t	2013-01-04 21:08:22.825979	2013-01-04 21:08:22.825979
4	15	t	2013-01-04 21:08:22.829614	2013-01-04 21:08:22.829614
5	20	t	2013-01-04 21:08:22.832482	2013-01-04 21:08:22.832482
6	25	t	2013-01-04 21:08:22.835503	2013-01-04 21:08:22.835503
7	30	t	2013-01-04 21:08:22.838347	2013-01-04 21:08:22.838347
8	35	t	2013-01-04 21:08:22.841086	2013-01-04 21:08:22.841086
9	50	f	2013-01-04 21:08:22.844043	2013-01-04 21:08:22.844043
\.


ALTER TABLE discount_percentages ENABLE TRIGGER ALL;

--
-- Name: discount_percentages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('discount_percentages_id_seq', 9, true);


--
-- PostgreSQL database dump complete
--

