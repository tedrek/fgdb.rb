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
-- Name: privileges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('privileges_id_seq', 39, true);


--
-- Data for Name: privileges; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE privileges DISABLE TRIGGER ALL;

COPY privileges (id, name, created_at, updated_at, restrict) FROM stdin;
4	skedjulnator	2011-01-29 00:51:40.955222	2011-01-29 00:51:40.955222	t
5	create_donations	2011-01-29 00:51:41.007223	2011-01-29 00:51:41.007223	t
10	view_donations	2011-01-29 01:06:13.031549	2011-01-29 01:06:13.031549	t
11	change_donations	2011-01-29 01:06:13.051549	2011-01-29 01:06:13.051549	t
12	create_sales	2011-01-29 01:06:13.071549	2011-01-29 01:06:13.071549	t
13	view_sales	2011-01-29 01:06:13.09155	2011-01-29 01:06:13.09155	t
14	change_sales	2011-01-29 01:06:13.11555	2011-01-29 01:06:13.11555	t
15	create_disbursements	2011-01-29 01:06:13.14355	2011-01-29 01:06:13.14355	t
16	view_disbursements	2011-01-29 01:06:13.183551	2011-01-29 01:06:13.183551	t
17	change_disbursements	2011-01-29 01:06:13.215551	2011-01-29 01:06:13.215551	t
18	create_gizmo_returns	2011-01-29 01:06:13.235551	2011-01-29 01:06:13.235551	t
19	view_gizmo_returns	2011-01-29 01:06:13.259552	2011-01-29 01:06:13.259552	t
20	change_gizmo_returns	2011-01-29 01:06:13.283552	2011-01-29 01:06:13.283552	t
21	create_recyclings	2011-01-29 01:06:13.303552	2011-01-29 01:06:13.303552	t
22	view_recyclings	2011-01-29 01:06:13.327552	2011-01-29 01:06:13.327552	t
23	change_recyclings	2011-01-29 01:06:13.347553	2011-01-29 01:06:13.347553	t
24	manage_contacts	2011-01-29 01:06:13.363553	2011-01-29 01:06:13.363553	t
25	manage_workers	2011-01-29 01:06:13.383553	2011-01-29 01:06:13.383553	t
26	manage_volunteer_hours	2011-01-29 01:06:13.535555	2011-01-29 01:06:13.535555	t
27	till_adjustments	2011-01-29 01:06:13.555555	2011-01-29 01:06:13.555555	t
28	role_contact_manager	2011-01-29 01:06:13.575555	2011-01-29 01:06:13.575555	t
29	role_store	2011-01-29 01:06:13.619556	2011-01-29 01:06:13.619556	t
30	role_front_desk	2011-01-29 01:06:13.675557	2011-01-29 01:06:13.675557	t
31	role_tech_support	2011-01-29 01:06:13.727557	2011-01-29 01:06:13.727557	t
32	schedule_volunteers	2011-02-26 00:29:51.366647	2011-02-26 00:29:51.366647	t
33	admin_skedjul	2011-02-26 00:29:51.430641	2011-02-26 00:29:51.430641	t
34	sign_off_spec_sheets	2011-02-26 00:30:06.094767	2011-02-26 00:30:06.094767	t
35	issue_store_credit	2011-04-01 19:27:44.860701	2011-04-01 19:27:44.860701	t
36	data_security	2012-12-08 05:39:52.219386	2012-12-08 05:39:52.219386	t
37	pay_invoices	2012-12-08 05:39:52.782806	2012-12-08 05:39:52.782806	t
38	price_systems	2012-12-08 05:39:55.495202	2012-12-08 05:39:55.495202	f
39	manage_pricing	2012-12-08 05:39:55.518255	2012-12-08 05:39:55.518255	t
\.


ALTER TABLE privileges ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

