--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: discount_names_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('discount_names_id_seq', 10, true);


--
-- Data for Name: discount_names; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE discount_names DISABLE TRIGGER ALL;

COPY discount_names (id, description, available, created_at, updated_at) FROM stdin;
1	Old Coupon	f	2013-01-04 21:08:22.731638	2013-01-04 21:08:22.731638
2	Old Bulk	f	2013-01-04 21:08:22.737593	2013-01-04 21:08:22.737593
3	Old One Time	f	2013-01-04 21:08:22.74057	2013-01-04 21:08:22.74057
4	None	t	2013-01-04 21:08:22.744112	2013-01-04 21:08:22.744112
5	Volunteer	t	2013-01-04 21:08:22.74692	2013-01-04 21:08:22.74692
6	Donor	t	2013-01-04 21:08:22.749606	2013-01-04 21:08:22.749606
7	Friend	t	2013-01-04 21:08:22.752571	2013-01-04 21:08:22.752571
8	Chinook	t	2013-01-04 21:08:22.755173	2013-01-04 21:08:22.755173
9	Student	t	2013-01-04 21:08:22.757821	2013-01-04 21:08:22.757821
10	Grants	t	2013-01-04 21:08:22.761308	2013-01-04 21:08:22.761308
\.


ALTER TABLE discount_names ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

