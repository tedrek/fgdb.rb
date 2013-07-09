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
-- Data for Name: rosters; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE rosters DISABLE TRIGGER ALL;

COPY rosters (id, name, created_at, updated_at, enabled, limit_shift_signup_by_program, contact_type_id, restrict_to_every_n_days, restrict_from_sked_id) FROM stdin;
4	Hardware ID	2011-02-23 20:05:04.987982	2011-02-23 20:05:04.987982	t	f	\N	\N	\N
5	System Evaluation	2011-02-23 20:05:18.939492	2011-02-23 20:05:18.939492	t	f	\N	\N	\N
6	Build Workshops	2011-02-23 20:05:42.719256	2011-02-23 20:05:42.719256	t	f	\N	\N	\N
7	Laptop	2011-02-23 20:05:53.69674	2011-02-23 20:05:53.69674	t	f	\N	\N	\N
8	Mac	2011-02-23 20:06:03.04779	2011-02-23 20:06:03.04779	t	f	\N	\N	\N
9	Spanish Build	2011-02-23 20:06:29.806686	2011-02-23 20:06:29.806686	t	f	\N	\N	\N
10	Server Build	2011-02-23 20:06:44.105559	2011-02-23 20:06:44.105559	t	f	\N	\N	\N
11	Receiving	2011-02-23 20:07:21.511792	2011-02-23 20:07:21.511792	t	f	\N	\N	\N
12	Recycling	2011-02-23 20:07:33.751952	2011-02-23 20:07:33.751952	t	f	\N	\N	\N
13	Printerland	2011-02-23 20:07:45.8237	2011-02-23 20:07:45.8237	t	f	\N	\N	\N
14	Misc	2011-02-23 20:08:09.596855	2011-02-23 20:08:09.596855	t	f	\N	\N	\N
15	Prebuild Interns	2011-02-26 15:10:54.852705	2011-02-26 15:10:54.852705	t	f	\N	\N	\N
16	Getting Started Classes	2011-02-26 16:13:20.575947	2011-02-26 16:13:20.575947	t	f	\N	\N	\N
17	Command Line	2011-02-26 16:24:13.278205	2011-02-26 16:24:13.278205	t	f	\N	\N	\N
18	Monthly Classes	2011-02-26 16:29:10.355836	2011-02-26 16:29:10.355836	t	f	\N	\N	\N
19	Advanced Testing	2011-08-19 15:30:24.162047	2011-08-19 15:30:24.162047	t	f	\N	\N	\N
21	Tech Support Interns	2011-10-01 10:55:13.581049	2011-10-01 10:57:16.084936	t	f	\N	\N	\N
22	Front Desk Interns	2011-10-01 10:57:32.382146	2011-10-01 10:57:32.382146	t	f	\N	\N	\N
23	Recycling Interns	2011-10-01 13:40:37.173639	2011-10-01 13:40:37.173639	t	f	\N	\N	\N
24	Thrift Store Interns	2011-10-01 13:41:41.562456	2011-10-01 13:41:41.562456	t	f	\N	\N	\N
25	Receiving Interns	2011-10-01 13:42:06.371791	2011-10-01 13:42:06.371791	t	f	\N	\N	\N
26	Printers Interns	2011-10-01 13:42:47.173088	2011-10-01 13:42:47.173088	t	f	\N	\N	\N
27	Hardware Grants Interns	2011-10-01 13:43:18.748062	2011-10-01 13:43:18.748062	t	f	\N	\N	\N
28	Advanced Testing Interns	2011-10-01 13:43:43.61414	2011-10-01 13:43:43.61414	t	f	\N	\N	\N
29	Build Instructors	2011-10-01 13:44:06.912915	2011-10-01 13:44:15.107009	t	f	\N	\N	\N
\.


ALTER TABLE rosters ENABLE TRIGGER ALL;

--
-- Name: rosters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('rosters_id_seq', 31, true);


--
-- PostgreSQL database dump complete
--

