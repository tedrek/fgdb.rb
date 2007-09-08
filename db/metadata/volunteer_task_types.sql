--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: volunteer_task_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('volunteer_task_types', 'id'), 56, true);


--
-- Data for Name: volunteer_task_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE volunteer_task_types DISABLE TRIGGER ALL;

COPY volunteer_task_types (id, description, parent_id, hours_multiplier, instantiable, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
17	program	0	1.000	f	0	2006-12-13 10:45:23	2006-12-13 10:45:23	1	1
27	adoption	17	1.000	f	0	2006-12-13 10:49:16	2006-12-13 10:49:16	1	1
23	cleaning	27	2.000	t	1	2006-12-13 10:49:27	2006-12-13 10:47:07	1	1
22	monitors	27	2.000	t	1	2006-12-13 10:49:34	2006-12-13 10:46:55	1	1
28	receiving	27	1.000	t	0	2006-12-13 10:49:54	2006-12-13 10:49:54	1	1
29	recycling	27	1.000	t	0	2006-12-13 10:50:04	2006-12-13 10:50:04	1	1
21	quality control	24	1.000	t	2	2006-12-13 11:00:21	2006-12-13 10:46:44	1	1
30	teaching	17	1.000	t	0	2006-12-13 11:04:23	2006-12-13 11:04:23	1	1
31	massage	17	4.000	t	0	2006-12-13 11:04:35	2006-12-13 11:04:35	1	1
32	slacking	17	0.000	t	0	2006-12-13 21:14:14	2006-12-13 21:14:14	1	1
47	repair	24	1.000	t	0	2006-12-30 08:40:54.425307	2006-12-30 08:40:54.425307	1	1
49	sorting	24	1.000	t	0	2006-12-30 08:40:54.441757	2006-12-30 08:40:54.441757	1	1
33	admin	17	1.000	t	1	2006-12-30 18:21:20	2006-12-30 08:40:54	1	1
35	computers for kids	17	1.000	t	1	2006-12-30 18:22:08	2006-12-30 08:40:54	1	1
36	CREAM	17	1.000	t	1	2006-12-30 18:22:10	2006-12-30 08:40:54	1	1
38	education	17	1.000	t	1	2006-12-30 18:22:11	2006-12-30 08:40:54	1	1
40	front desk	17	1.000	t	1	2006-12-30 18:22:14	2006-12-30 08:40:54	1	1
42	misc	17	1.000	t	1	2006-12-30 18:22:55	2006-12-30 08:40:54	1	1
43	orientation	17	1.000	t	1	2006-12-30 18:22:56	2006-12-30 08:40:54	1	1
44	outreach	17	1.000	t	1	2006-12-30 18:22:58	2006-12-30 08:40:54	1	1
45	printers	17	1.000	t	1	2006-12-30 18:22:59	2006-12-30 08:40:54	1	1
46	programming	17	1.000	t	1	2006-12-30 18:23:00	2006-12-30 08:40:54	1	1
48	sales	17	1.000	t	1	2006-12-30 18:23:02	2006-12-30 08:40:54	1	1
50	support	17	1.000	t	1	2006-12-30 18:23:03	2006-12-30 08:40:54	1	1
51	system administration	17	1.000	t	1	2006-12-30 18:23:04	2006-12-30 08:40:54	1	1
34	advanced testing	24	1.000	t	2	2006-12-30 18:27:25	2006-12-30 08:40:54	1	1
37	data entry	27	1.000	t	1	2006-12-30 18:27:34	2006-12-30 08:40:54	1	1
39	enterprise	24	1.000	t	2	2006-12-30 18:27:40	2006-12-30 08:40:54	1	1
41	laptops	24	1.000	t	2	2006-12-30 18:27:45	2006-12-30 08:40:54	1	1
52	testing	27	1.000	t	1	2006-12-30 18:28:28	2006-12-30 08:40:54	1	1
53	macintosh	24	1.000	t	0	2007-01-05 16:10:33	2007-01-05 16:10:33	1	1
25	evaluation	24	1.000	t	0	2006-12-13 10:48:21	2006-12-13 10:48:21	1	1
24	build	17	1.000	f	0	2006-12-13 10:47:39	2006-12-13 10:47:39	1	1
26	build, assembly	24	1.000	t	0	2006-12-13 10:48:52	2006-12-13 10:48:52	1	1
\.


ALTER TABLE volunteer_task_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

