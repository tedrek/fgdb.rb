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
-- Data for Name: volunteer_task_types; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE volunteer_task_types DISABLE TRIGGER ALL;

COPY volunteer_task_types (id, description, hours_multiplier, instantiable, lock_version, updated_at, created_at, name, effective_on, ineffective_on, program_id, adoption_credit) FROM stdin;
42	misc	1.000	t	2	2010-03-27 01:54:34.727845	2006-12-30 08:40:54	misc	\N	\N	10	\N
28	receiving	1.000	t	1	2010-03-27 01:54:34.767845	2006-12-13 10:49:54	receiving	\N	\N	1	\N
51	system administration	1.000	t	2	2010-03-27 01:54:34.879847	2006-12-30 08:40:54	system_administration	\N	\N	10	\N
33	admin	1.000	t	2	2010-03-27 01:54:34.895848	2006-12-30 08:40:54	admin	\N	\N	10	\N
52	testing	1.000	t	2	2010-03-27 01:54:34.995849	2006-12-30 08:40:54	testing	\N	\N	1	\N
44	outreach	1.000	t	2	2010-03-27 01:54:35.03985	2006-12-30 08:40:54	outreach	\N	\N	10	\N
40	front desk	1.000	t	2	2010-03-27 01:54:35.06785	2006-12-30 08:40:54	front_desk	\N	\N	10	\N
29	recycling	1.000	t	1	2010-03-27 01:54:35.079851	2006-12-13 10:50:04	recycling	\N	\N	1	\N
25	evaluation	1.000	t	1	2010-03-27 01:54:35.099851	2006-12-13 10:48:21	evaluation	\N	\N	2	\N
21	quality control	1.000	t	3	2010-03-27 01:54:35.111851	2006-12-13 10:46:44	quality_control	\N	\N	2	\N
26	build, assembly	1.000	t	1	2010-03-27 01:54:35.127851	2006-12-13 10:48:52	assembly	\N	\N	2	\N
55	cleaning	1.000	t	3	2010-03-27 01:54:35.183852	2006-12-13 10:47:07	cleaning	2009-10-02 00:00:00	\N	1	\N
49	hardware id	1.000	t	1	2010-03-27 01:54:35.271854	2006-12-30 08:40:54.441757	sorting	\N	\N	2	\N
56	monitors	1.000	t	3	2010-03-27 01:54:35.215853	2006-12-13 10:46:55	monitors	2009-10-02 00:00:00	2011-07-31 00:00:00	1	\N
31	massage	4.000	t	1	2010-03-27 01:54:34.711845	2006-12-13 11:04:35	massage	\N	2011-07-31 00:00:00	10	\N
47	repair	1.000	t	1	2010-03-27 01:54:34.739845	2006-12-30 08:40:54.425307	repair	\N	2011-07-31 00:00:00	2	\N
35	computers for kids	1.000	t	2	2010-03-27 01:54:34.831847	2006-12-30 08:40:54	computers_for_kids	\N	2011-07-31 00:00:00	10	\N
46	programming	1.000	t	2	2010-03-27 01:54:34.923848	2006-12-30 08:40:54	programming	\N	2011-07-31 00:00:00	10	\N
36	CREAM	1.000	t	2	2010-03-27 01:54:34.955849	2006-12-30 08:40:54	cream	\N	2011-07-31 00:00:00	10	\N
37	data entry	1.000	t	2	2010-03-27 01:54:34.967849	2006-12-30 08:40:54	data_entry	\N	2011-07-31 00:00:00	1	\N
43	orientation	1.000	t	2	2010-03-27 01:54:35.05185	2006-12-30 08:40:54	orientation	\N	2011-07-31 00:00:00	10	\N
54	case management	1.000	t	1	2010-03-27 01:54:35.155852	2008-12-12 17:17:50.467874	case management	\N	2011-07-31 00:00:00	2	\N
23	cleaning	2.000	t	3	2010-03-27 01:54:35.171852	2006-12-13 10:47:07	cleaning	\N	2011-07-31 00:00:00	1	\N
22	monitors	2.000	t	3	2010-03-27 01:54:35.199853	2006-12-13 10:46:55	monitors	\N	2011-07-31 00:00:00	1	\N
32	slacking	0.000	t	1	2010-03-27 01:54:34.695844	2006-12-13 21:14:14	slacking	\N	2011-07-31 00:00:00	8	\N
30	teaching	1.000	t	1	2010-03-27 01:54:34.755845	2006-12-13 11:04:23	teaching	\N	\N	14	\N
38	education	1.000	t	2	2010-03-27 01:54:35.143852	2006-12-30 08:40:54	education	\N	\N	14	\N
53	macintosh	1.000	t	1	2010-03-27 01:54:34.867847	2007-01-05 16:10:33	macintosh	\N	\N	3	\N
34	advanced testing	1.000	t	3	2010-03-27 01:54:35.02385	2006-12-30 08:40:54	advanced_testing	\N	\N	3	\N
39	server	1.000	t	4	2010-06-26 01:06:56.392275	2006-12-30 08:40:54	server	\N	\N	3	\N
48	sales	1.000	t	2	2010-03-27 01:54:34.819846	2006-12-30 08:40:54	sales	\N	\N	4	\N
45	printers	1.000	t	2	2010-03-27 01:54:34.939848	2006-12-30 08:40:54	printers	\N	\N	1	\N
58	Library	1.000	t	1	2010-03-27 01:54:35.243853	2010-02-19 23:43:53.730732	library	\N	\N	10	\N
57	A/V	1.000	t	1	2010-03-27 01:54:35.227853	2010-02-19 23:43:53.706732	av	\N	\N	4	\N
59	grants	1.000	t	1	2010-03-27 01:54:35.255853	2010-02-19 23:43:55.222729	hardware_grants	\N	\N	4	\N
60	plug into portland	1.000	t	0	2012-03-09 12:14:25.54936	2012-03-09 12:14:25.54936	plug_into_portland	\N	\N	1	\N
61	board work	1.000	t	0	2012-04-12 12:16:55.494388	2012-04-12 12:16:55.494388	board	\N	\N	10	\N
50	tech support	1.000	t	3	2012-05-05 09:11:40.739159	2006-12-30 08:40:54	support	\N	\N	14	\N
41	laptops	1.000	t	4	2012-05-05 09:31:05.809019	2006-12-30 08:40:54	laptops	\N	\N	2	t
62	facilities	1.000	t	0	2012-12-08 05:39:56.176809	2012-12-08 05:39:56.176809	facilities	\N	\N	10	\N
63	laptop prebuild	1.000	t	0	2013-07-09 11:51:52.068059	2013-07-09 11:51:52.068059	laptop_prebuild	\N	\N	1	f
\.


ALTER TABLE volunteer_task_types ENABLE TRIGGER ALL;

--
-- Name: volunteer_task_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('volunteer_task_types_id_seq', 63, true);


--
-- PostgreSQL database dump complete
--

