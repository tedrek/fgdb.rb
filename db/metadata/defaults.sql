--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Name: defaults_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stillflame
--

SELECT pg_catalog.setval(pg_catalog.pg_get_serial_sequence('"defaults"', 'id'), 5, true);


--
-- Data for Name: defaults; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE "defaults" DISABLE TRIGGER ALL;

COPY "defaults" (id, name, value, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
3	tax id	Federal Tax I.D.  93-1292010	0	2007-04-16 14:16:07	2007-04-16 14:16:07	1	1
6	country	United States	0	2007-04-16 14:16:42	2007-04-16 14:16:42	1	1
4	address image	/images/hdr-address.gif	0	2007-04-16 14:16:41	2007-04-16 14:16:41	1	1
5	business id		0	2007-04-16 14:22:06	2007-04-16 14:22:06	1	1
7	contact info	addr: 1731 SE 10th Portland, OR 97214 tele: 503.232.9350 email: info@freegeek.org	0	2007-04-16 14:22:16	2007-04-16 14:22:16	1	1
2	state_or_province	OR	1	2007-04-16 14:33:55	2007-04-16 14:15:25	1	1
1	city	Portland	1	2007-04-16 14:34:29	2007-04-16 14:15:10	1	1
\.


ALTER TABLE "defaults" ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

