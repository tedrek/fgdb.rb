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
-- Data for Name: gizmo_type_groups; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE gizmo_type_groups DISABLE TRIGGER ALL;

COPY gizmo_type_groups (id, name, created_at, updated_at) FROM stdin;
1	All Systems	2011-11-19 16:02:07.714152	2011-11-19 16:02:07.714152
2	All Laptops	2011-11-19 16:04:30.915174	2011-11-19 16:04:30.915174
3	All Macs	2011-11-19 16:05:08.02319	2011-11-19 16:05:08.02319
4	Parts	2011-11-19 16:06:13.488722	2011-11-19 16:06:13.488722
5	Peripherals	2011-11-19 16:07:07.212018	2011-11-19 16:07:07.212018
6	Advanced Testing Family	2012-03-14 15:51:04.558499	2012-03-14 15:51:04.558499
7	Non-Mac Laptop Family	2012-03-14 15:57:35.488094	2012-03-14 15:57:35.488094
8	Non-Mac Desktop Family	2012-03-14 15:59:12.618385	2012-03-14 15:59:12.618385
\.


ALTER TABLE gizmo_type_groups ENABLE TRIGGER ALL;

--
-- Name: gizmo_type_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gizmo_type_groups_id_seq', 8, true);


--
-- PostgreSQL database dump complete
--

