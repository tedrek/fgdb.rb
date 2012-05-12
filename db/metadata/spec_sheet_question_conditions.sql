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
-- Name: spec_sheet_question_conditions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('spec_sheet_question_conditions_id_seq', 29, true);


--
-- Data for Name: spec_sheet_question_conditions; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE spec_sheet_question_conditions DISABLE TRIGGER ALL;

COPY spec_sheet_question_conditions (id, spec_sheet_question_id, name, operator, expected_value, created_at, updated_at) FROM stdin;
1	1	type_id	=	7	\N	\N
2	2	type_id	=	7	\N	\N
3	2	case	=~	^(r|R)	\N	\N
4	3	type_id	=	7	\N	\N
5	4	type_id	=	7	\N	\N
6	4	maximum_power_supplies	>	1	\N	\N
7	5	type_id	=	7	\N	\N
8	6	type_id	=	7	\N	\N
9	6	maximum_processors	>	1	\N	\N
10	7	type_id	=	7	\N	\N
11	8	type_id	=	7	\N	\N
12	8	maximum_hard_drives	>	1	\N	\N
13	9	type_id	=	7	\N	\N
14	9	maximum_hard_drives	>	1	\N	\N
15	10	type_id	=	7	\N	\N
16	10	maximum_hard_drives	>	1	\N	\N
17	13	type_id	=	-1	2012-03-31 00:37:35.600938	2012-03-31 00:37:35.600938
18	14	type_id	=	2	2012-03-31 00:37:35.701519	2012-03-31 00:37:35.701519
19	14	type_id	=	5	2012-03-31 00:37:35.706738	2012-03-31 00:37:35.706738
20	14	type_id	=	3	2012-03-31 00:37:35.711526	2012-03-31 00:37:35.711526
21	14	type_id	=	1	2012-03-31 00:37:35.716266	2012-03-31 00:37:35.716266
22	15	type_id	=	4	2012-03-31 00:37:35.772176	2012-03-31 00:37:35.772176
23	16	type_id	=	4	2012-03-31 00:37:35.782773	2012-03-31 00:37:35.782773
24	17	has_wireless_switch	=~	^(y|Y)	2012-03-31 00:37:35.793948	2012-03-31 00:37:35.793948
25	17	type_id	=	4	2012-03-31 00:37:35.798573	2012-03-31 00:37:35.798573
26	18	type_id	=	4	2012-03-31 00:37:35.808907	2012-03-31 00:37:35.808907
27	19	has_wireless_key_combo	=~	^(y|Y)	2012-03-31 00:37:35.820034	2012-03-31 00:37:35.820034
28	19	type_id	=	4	2012-03-31 00:37:35.824606	2012-03-31 00:37:35.824606
29	20	type_id	=	4	2012-03-31 00:37:35.834922	2012-03-31 00:37:35.834922
\.


ALTER TABLE spec_sheet_question_conditions ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

