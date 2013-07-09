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
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE holidays DISABLE TRIGGER ALL;

COPY holidays (id, name, holiday_date, is_all_day, start_time, end_time, frequency_type_id, schedule_id, weekday_id) FROM stdin;
30	Christmas	2010-12-25	t	08:00:00	08:00:00	6	1	6
31	Independence Day	2010-07-03	t	08:00:00	08:00:00	6	1	6
32	Labor Day	2010-09-04	t	08:00:00	08:00:00	6	1	6
33	May Day	2010-05-01	t	08:00:00	08:00:00	6	1	6
34	Memorial Day	2010-05-29	t	08:00:00	08:00:00	6	1	6
35	Thanksgiving	2010-11-25	t	08:00:00	08:00:00	6	1	4
36	Thanksgiving	2010-11-26	t	08:00:00	08:00:00	6	1	5
37	Thanksgiving	2010-11-27	t	08:00:00	08:00:00	6	1	6
26	Christmas	2009-12-25	t	\N	\N	6	1	5
27	Christmas	2009-12-26	t	\N	\N	6	1	6
28	New Years	2010-01-01	t	\N	\N	6	1	5
29	New Years	2010-01-02	t	\N	\N	6	1	6
9	Memorial Day	2008-05-24	t	\N	\N	6	1	6
12	Independence Day	2008-07-05	t	\N	\N	6	1	6
13	Labor Day	2008-08-30	t	\N	\N	6	1	6
15	Thanksgiving	2008-11-29	t	\N	\N	6	1	6
17	Thanksgiving	2008-11-27	t	\N	\N	6	1	4
14	Thanksgiving	2008-11-28	t	\N	\N	6	1	5
11	Independence Day	2008-07-04	t	\N	\N	6	1	5
16	Christmas	2008-12-25	t	\N	\N	6	1	4
8	May Day	2008-05-01	t	\N	\N	6	1	4
18	New Year's Day	2009-01-01	t	11:00:00	11:00:00	6	1	0
19	May Day	2009-05-01	t	\N	\N	6	1	5
20	Memorial Day	2009-05-23	t	\N	\N	6	1	6
21	Independence Day	2009-07-04	\N	\N	\N	6	1	6
22	Labor Day	2009-09-05	\N	\N	\N	6	1	6
23	Thanksgiving	2009-11-26	\N	\N	\N	6	1	4
24	Thanksgiving	2009-11-27	\N	\N	\N	6	1	5
25	Thanksgiving	2009-11-28	\N	\N	\N	6	1	6
39	New Years	2011-01-01	t	08:00:00	08:00:00	6	1	6
40	Independence Day	2011-07-02	t	08:00:00	08:00:00	6	1	2
41	Memorial Day	2011-05-28	t	08:00:00	08:00:00	6	1	6
42	Labor Day	2011-09-03	t	08:00:00	08:00:00	6	1	6
43	Thanksgiving	2011-11-24	t	08:00:00	08:00:00	6	1	4
44	Thanksgiving	2011-11-25	t	08:00:00	08:00:00	6	1	5
45	Thanksgiving	2011-11-26	t	08:00:00	08:00:00	6	1	6
46	Christmas	2011-12-24	t	08:00:00	08:00:00	6	1	6
47	New Years	2011-12-31	t	08:00:00	08:00:00	6	1	6
55	Thanksgiving	2012-11-23	t	17:30:00	17:30:00	6	1	5
57	Christmas Eve	2012-12-22	t	17:30:00	17:30:00	6	1	6
58	Christmas	2012-12-25	t	17:00:00	17:00:00	6	1	2
59	New Years	2013-01-01	t	17:00:00	17:00:00	6	1	2
50	May Day	2012-05-01	t	17:00:00	17:00:00	6	1	2
51	Memorial Day	2012-05-26	t	17:00:00	17:00:00	1	1	6
52	Independence Day	2012-07-04	t	17:00:00	17:00:00	6	1	3
53	Labor Day	2012-09-01	t	17:00:00	17:00:00	6	1	6
54	Thanksgiving	2012-11-22	t	17:00:00	17:00:00	6	1	4
56	Thanksgiving	2012-11-24	t	17:30:00	17:30:00	6	1	6
60	Independence Day	2012-07-03	t	09:00:00	09:00:00	\N	1	2
\.


ALTER TABLE holidays ENABLE TRIGGER ALL;

--
-- Name: holidays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('holidays_id_seq', 60, true);


--
-- PostgreSQL database dump complete
--

