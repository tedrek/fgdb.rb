--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: discount_schedules_gizmo_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('discount_schedules_gizmo_types', 'id'), 37, true);


--
-- Data for Name: discount_schedules_gizmo_types; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE discount_schedules_gizmo_types DISABLE TRIGGER ALL;

COPY discount_schedules_gizmo_types (id, gizmo_type_id, discount_schedule_id, multiplier, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
2	6	4	0.500	0	2006-12-19 18:29:37-08	2006-12-19 18:29:37-08	1	1
18	17	7	1.000	0	2006-12-20 08:55:50-08	2006-12-20 08:55:50-08	1	1
19	17	8	1.000	0	2006-12-20 08:55:50-08	2006-12-20 08:55:50-08	1	1
20	17	9	1.000	0	2006-12-20 08:55:50-08	2006-12-20 08:55:50-08	1	1
21	17	4	0.900	0	2006-12-20 08:55:50-08	2006-12-20 08:55:50-08	1	1
22	17	5	0.950	0	2006-12-20 08:55:50-08	2006-12-20 08:55:50-08	1	1
23	13	7	0.750	0	2006-12-20 08:56:42-08	2006-12-20 08:56:42-08	1	1
24	13	8	0.900	0	2006-12-20 08:56:42-08	2006-12-20 08:56:42-08	1	1
25	13	9	1.000	0	2006-12-20 08:56:42-08	2006-12-20 08:56:42-08	1	1
26	13	4	0.500	0	2006-12-20 08:56:42-08	2006-12-20 08:56:42-08	1	1
27	13	5	0.750	0	2006-12-20 08:56:42-08	2006-12-20 08:56:42-08	1	1
28	18	7	1.000	0	2006-12-20 08:57:09-08	2006-12-20 08:57:09-08	1	1
29	18	8	1.000	0	2006-12-20 08:57:09-08	2006-12-20 08:57:09-08	1	1
30	18	9	1.000	0	2006-12-20 08:57:09-08	2006-12-20 08:57:09-08	1	1
31	18	4	0.900	0	2006-12-20 08:57:09-08	2006-12-20 08:57:09-08	1	1
32	18	5	1.000	0	2006-12-20 08:57:09-08	2006-12-20 08:57:09-08	1	1
33	5	7	\N	0	2006-12-20 08:58:11-08	2006-12-20 08:58:11-08	1	1
34	5	8	\N	0	2006-12-20 08:58:11-08	2006-12-20 08:58:11-08	1	1
35	5	9	\N	0	2006-12-20 08:58:11-08	2006-12-20 08:58:11-08	1	1
36	5	4	\N	0	2006-12-20 08:58:11-08	2006-12-20 08:58:11-08	1	1
37	5	5	\N	0	2006-12-20 08:58:11-08	2006-12-20 08:58:11-08	1	1
\.


ALTER TABLE discount_schedules_gizmo_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

