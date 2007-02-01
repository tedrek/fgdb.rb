--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: gizmo_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('gizmo_types', 'id'), 18, true);


--
-- Data for Name: gizmo_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE gizmo_types DISABLE TRIGGER ALL;

COPY gizmo_types (id, description, parent_id, lock_version, updated_at, created_at, created_by, updated_by, required_fee, suggested_fee) FROM stdin;
6	Laptop	4	0	2006-11-11 19:05:26-08	2006-11-11 19:05:26-08	1	1	0.00	4.00
2	LCD	1	2	2006-11-11 19:13:12-08	2006-09-25 11:21:53-07	1	1	0.00	0.00
12	Fax Machine	13	1	2006-11-11 19:16:11-08	2006-11-11 19:13:34-08	1	1	0.00	4.00
11	Scanner	13	1	2006-11-11 19:16:20-08	2006-11-11 19:09:38-08	1	1	0.00	3.00
10	Printer	13	1	2006-11-11 19:16:33-08	2006-11-11 19:09:26-08	1	1	0.00	4.00
9	Stereo System	13	1	2006-11-11 19:16:45-08	2006-11-11 19:09:10-08	1	1	0.00	4.00
8	DVD Player	13	1	2006-11-11 19:16:53-08	2006-11-11 19:08:52-08	1	1	0.00	4.00
7	VCR	13	1	2006-11-11 19:17:02-08	2006-11-11 19:08:37-08	1	1	0.00	4.00
1	Monitor	13	7	2006-11-11 19:17:12-08	2006-09-25 11:21:29-07	1	1	0.00	0.00
14	UPS	13	0	2006-11-11 19:18:08-08	2006-11-11 19:18:08-08	1	1	0.00	4.00
4	System	13	6	2006-11-11 19:18:18-08	2006-09-25 11:22:30-07	1	1	0.00	5.00
15	Sticker	17	1	2006-11-11 19:39:54-08	2006-11-11 19:19:08-08	1	1	0.00	0.00
16	T-Shirt	17	1	2006-11-11 19:40:03-08	2006-11-11 19:19:26-08	1	1	0.00	0.00
3	CRT	1	3	2006-12-19 18:08:47-08	2006-09-25 11:22:11-07	1	1	10.00	0.00
17	Schwag	0	3	2006-12-20 08:55:50-08	2006-11-11 19:39:41-08	1	1	0.00	0.00
13	Gizmo	0	2	2006-12-20 08:56:42-08	2006-11-11 19:16:03-08	1	1	0.00	0.00
18	1337 lappy	6	1	2006-12-20 08:57:09-08	2006-12-19 20:16:28-08	1	1	0.00	0.00
5	System w/builtin monitor	1	4	2006-12-20 08:58:11-08	2006-09-29 14:22:28-07	1	1	10.00	0.00
\.


ALTER TABLE gizmo_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

