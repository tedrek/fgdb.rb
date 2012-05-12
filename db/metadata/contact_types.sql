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
-- Name: contact_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contact_types_id_seq', 40, true);


--
-- Data for Name: contact_types; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE contact_types DISABLE TRIGGER ALL;

COPY contact_types (id, description, for_who, lock_version, updated_at, created_at, instantiable, name) FROM stdin;
12	adopter	per	0	2006-12-29 17:07:36.465725	2006-12-29 17:07:36.465725	t	adopter
26	offsite	per	0	2008-06-04 16:19:03.40664	2008-06-04 16:19:03.40664	t	offsite
27	bulk buyer	any	0	2008-06-27 22:34:21.493845	2008-06-27 22:34:21.493845	t	bulk_buyer
5	nonprofit	org	2	2006-11-25 00:49:18	2006-09-20 07:44:41	t	nonprofit
29	no mail	any	0	2008-12-05 19:01:57.61521	2008-12-05 19:01:57.61521	t	nomail
30	contributor	per	0	2009-04-10 00:48:31.391473	2009-04-10 00:48:31.391473	t	contributor
4	volunteer	per	2	2006-11-25 00:48:56	2006-09-20 07:44:25	t	volunteer
19	grantor	any	1	2006-12-29 17:07:36.526178	2006-12-29 17:07:36.526178	t	grantor
24	recycler	any	1	2006-12-29 17:07:36.567347	2006-12-29 17:07:36.567347	t	recycler
14	buyer	any	12	2006-12-29 17:07:36.513717	2006-12-29 17:07:36.513717	t	buyer
7	donor	any	2	2006-09-20 07:45:14	2006-09-20 07:45:14	t	donor
13	build	per	1	2006-12-29 17:07:36.511086	2006-12-29 17:07:36.511086	t	build
31	Completed Hardware Id	per	0	2011-02-26 00:30:05.842789	2011-02-26 00:30:05.842789	t	completed_hardware_id
32	Completed System Eval	per	0	2011-02-26 00:30:05.890785	2011-02-26 00:30:05.890785	t	completed_system_eval
33	student	per	0	2011-06-02 22:48:46.318437	2011-06-02 22:48:46.318437	t	student
34	laptop build	per	0	2011-06-24 20:42:49.020334	2011-06-24 20:42:49.020334	t	laptop_build
35	mac build	per	0	2011-06-24 20:42:49.249975	2011-06-24 20:42:49.249975	t	mac_build
36	server build	per	0	2011-06-24 20:42:49.261708	2011-06-24 20:42:49.261708	t	server_build
37	advanced testing	per	0	2011-06-24 20:42:49.273204	2011-06-24 20:42:49.273204	t	advanced_testing
38	completed commandline	per	0	2011-08-12 19:19:52.794098	2011-08-12 19:19:52.794098	t	completed_commandline
39	enewsletter	any	0	2011-09-23 19:56:02.377911	2011-09-23 19:56:02.377911	t	enewsletter
40	vnewsletter	any	0	2011-09-23 19:56:02.442628	2011-09-23 19:56:02.442628	t	vnewsletter
\.


ALTER TABLE contact_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

