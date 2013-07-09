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
-- Name: return_policies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('return_policies_id_seq', 4, true);


--
-- Data for Name: return_policies; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE return_policies DISABLE TRIGGER ALL;

COPY return_policies (id, name, description, text, created_at, updated_at) FROM stdin;
1	standard	14 DAY EXCHANGE	Unless otherwise specified, items may be returned within 14 days for a store credit. You must provide the original receipt at the time of return, and the items must be returned in the same condition in which they were sold.	2011-10-01 13:01:20.565775	2011-10-01 13:01:20.565775
2	as_is	AS-IS	Items marked "As-Is" cannot be returned for any reason; the additional risk is reflected in the low, low price	2011-10-01 13:01:20.701818	2011-10-01 13:01:20.701818
3	lcd	LCD MONITORS	may be returned for store credit within 30 days of purchase	2011-10-01 13:01:20.802989	2011-10-01 13:01:20.802989
4	system	SYSTEM WARRANTY	Please see attached document for details of hardware warranty and tech support policies. Info may also be found at freegeek.org/system-warranty	2011-10-01 13:01:20.821799	2012-12-08 05:39:56.415646
\.


ALTER TABLE return_policies ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

