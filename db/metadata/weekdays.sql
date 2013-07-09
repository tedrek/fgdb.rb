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
-- Data for Name: weekdays; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE weekdays DISABLE TRIGGER ALL;

COPY weekdays (id, name, short_name, is_open, start_time, end_time, open_time, close_time) FROM stdin;
1	Monday	Mon	f	08:00:00	19:00:00	10:00:00	18:00:00
5	Friday	Fri	t	08:00:00	19:00:00	10:00:00	18:00:00
0	Sunday	Sun	f	08:00:00	19:00:00	10:00:00	18:00:00
2	Tuesday	Tue	t	08:00:00	19:00:00	10:00:00	18:00:00
4	Thursday	Thu	t	08:00:00	19:00:00	10:00:00	18:00:00
6	Saturday	Sat	t	08:00:00	19:00:00	10:00:00	18:00:00
3	Wednesday	Wed	t	08:00:00	19:00:00	10:00:00	18:00:00
\.


ALTER TABLE weekdays ENABLE TRIGGER ALL;

--
-- Name: weekdays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('weekdays_id_seq', 50, false);


--
-- PostgreSQL database dump complete
--

