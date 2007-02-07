--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: volunteer_task_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fgdb
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('volunteer_task_types', 'id'), 53, true);


--
-- Data for Name: volunteer_task_types; Type: TABLE DATA; Schema: public; Owner: fgdb
--

ALTER TABLE volunteer_task_types DISABLE TRIGGER ALL;

COPY volunteer_task_types (id, description, parent_id, hours_multiplier, instantiable, lock_version, updated_at, created_at, created_by, updated_by, required) FROM stdin;
17	program	0	1.000	f	0	2006-12-13 10:45:23-08	2006-12-13 10:45:23-08	1	1	t
18	community service	0	1.000	f	0	2006-12-13 10:45:42-08	2006-12-13 10:45:42-08	1	1	f
19	school	18	1.000	t	0	2006-12-13 10:46:09-08	2006-12-13 10:46:09-08	1	1	t
24	build	17	1.000	f	0	2006-12-13 10:47:39-08	2006-12-13 10:47:39-08	1	1	t
25	system eval	24	1.000	t	0	2006-12-13 10:48:21-08	2006-12-13 10:48:21-08	1	1	t
26	assembly	24	1.000	t	0	2006-12-13 10:48:52-08	2006-12-13 10:48:52-08	1	1	t
27	adoption	17	1.000	f	0	2006-12-13 10:49:16-08	2006-12-13 10:49:16-08	1	1	t
23	cleaning	27	2.000	t	1	2006-12-13 10:49:27-08	2006-12-13 10:47:07-08	1	1	t
22	monitors	27	2.000	t	1	2006-12-13 10:49:34-08	2006-12-13 10:46:55-08	1	1	t
28	receiving	27	1.000	t	0	2006-12-13 10:49:54-08	2006-12-13 10:49:54-08	1	1	t
29	recycling	27	1.000	t	0	2006-12-13 10:50:04-08	2006-12-13 10:50:04-08	1	1	t
21	quality control	24	1.000	t	2	2006-12-13 11:00:21-08	2006-12-13 10:46:44-08	1	1	t
30	teaching	17	1.000	t	0	2006-12-13 11:04:23-08	2006-12-13 11:04:23-08	1	1	t
31	massage	17	4.000	t	0	2006-12-13 11:04:35-08	2006-12-13 11:04:35-08	1	1	t
20	punitive	18	0.000	t	1	2006-12-13 20:36:30-08	2006-12-13 10:46:23-08	1	1	t
32	slacking	17	0.000	t	0	2006-12-13 21:14:14-08	2006-12-13 21:14:14-08	1	1	t
47	repair	24	1.000	t	0	2006-12-30 08:40:54.425307-08	2006-12-30 08:40:54.425307-08	1	1	t
49	sorting	24	1.000	t	0	2006-12-30 08:40:54.441757-08	2006-12-30 08:40:54.441757-08	1	1	t
33	admin	17	1.000	t	1	2006-12-30 18:21:20-08	2006-12-30 08:40:54-08	1	1	t
35	computers for kids	17	1.000	t	1	2006-12-30 18:22:08-08	2006-12-30 08:40:54-08	1	1	t
36	CREAM	17	1.000	t	1	2006-12-30 18:22:10-08	2006-12-30 08:40:54-08	1	1	t
38	education	17	1.000	t	1	2006-12-30 18:22:11-08	2006-12-30 08:40:54-08	1	1	t
40	front desk	17	1.000	t	1	2006-12-30 18:22:14-08	2006-12-30 08:40:54-08	1	1	t
42	misc	17	1.000	t	1	2006-12-30 18:22:55-08	2006-12-30 08:40:54-08	1	1	t
43	orientation	17	1.000	t	1	2006-12-30 18:22:56-08	2006-12-30 08:40:54-08	1	1	t
44	outreach	17	1.000	t	1	2006-12-30 18:22:58-08	2006-12-30 08:40:54-08	1	1	t
45	printers	17	1.000	t	1	2006-12-30 18:22:59-08	2006-12-30 08:40:54-08	1	1	t
46	programming	17	1.000	t	1	2006-12-30 18:23:00-08	2006-12-30 08:40:54-08	1	1	t
48	sales	17	1.000	t	1	2006-12-30 18:23:02-08	2006-12-30 08:40:54-08	1	1	t
50	support	17	1.000	t	1	2006-12-30 18:23:03-08	2006-12-30 08:40:54-08	1	1	t
51	system administration	17	1.000	t	1	2006-12-30 18:23:04-08	2006-12-30 08:40:54-08	1	1	t
34	advanced testing	24	1.000	t	2	2006-12-30 18:27:25-08	2006-12-30 08:40:54-08	1	1	t
37	data entry	27	1.000	t	1	2006-12-30 18:27:34-08	2006-12-30 08:40:54-08	1	1	t
39	enterprise	24	1.000	t	2	2006-12-30 18:27:40-08	2006-12-30 08:40:54-08	1	1	t
41	laptops	24	1.000	t	2	2006-12-30 18:27:45-08	2006-12-30 08:40:54-08	1	1	t
52	testing	27	1.000	t	1	2006-12-30 18:28:28-08	2006-12-30 08:40:54-08	1	1	t
53	macintosh	24	1.000	t	0	2007-01-05 16:10:33-08	2007-01-05 16:10:33-08	1	1	t
\.


ALTER TABLE volunteer_task_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

