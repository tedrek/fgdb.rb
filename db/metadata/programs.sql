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
-- Data for Name: programs; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE programs DISABLE TRIGGER ALL;

COPY programs (id, name, description, created_at, updated_at, volunteer, adoption_credit) FROM stdin;
5	access	Internet Access	2009-10-31 15:12:15.049527	2009-10-31 15:12:15.049527	f	t
7	fundraising	Fundraising	2009-10-31 15:12:15.053527	2009-10-31 15:12:15.053527	f	t
8	overhead	Overhead	2009-10-31 15:12:15.053527	2009-10-31 15:12:15.053527	f	t
1	adoption	Adoption	2009-10-31 15:12:14.97353	2010-03-27 12:01:27.997399	t	t
11	recycling	Recycling	2010-10-28 13:22:47.350112	2010-10-28 13:22:47.350112	f	t
10	mixed	Mixed	2010-03-27 01:54:34.42384	2010-11-06 00:52:32.546186	t	t
15	replication	Replication	2011-07-07 13:00:05.678463	2011-07-07 13:00:05.678463	f	t
16	volunteer	Volunteer & Community Service	2011-07-07 13:11:04.638464	2011-07-07 13:11:04.638464	f	t
2	build	Build	2009-10-31 15:12:15.045528	2011-08-12 19:19:51.359646	t	f
12	spanish	Spanish Build	2010-11-06 00:52:32.810188	2011-08-12 19:19:51.42604	t	f
14	education	Education	2011-07-07 12:58:25.626449	2011-07-07 12:58:25.626449	t	t
4	reuse	Reuse & E-Waste Diversion	2009-10-31 15:12:15.049527	2009-10-31 15:12:15.049527	t	t
9	intern	Internships and Job Training	2010-03-27 01:54:34.139835	2011-08-12 19:19:51.419361	t	t
3	altbuild	Advanced Build	2009-10-31 15:12:15.045528	2009-10-31 15:12:15.045528	t	t
17	n/a	Not Applicable	2012-03-27 13:14:42.109174	2012-03-27 13:14:42.109174	f	t
\.


ALTER TABLE programs ENABLE TRIGGER ALL;

--
-- Name: programs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('programs_id_seq', 17, true);


--
-- PostgreSQL database dump complete
--

