--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('contracts_id_seq', 1, true);


--
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE contracts DISABLE TRIGGER ALL;

COPY contracts (id, name, description, label, notes, created_at, updated_at) FROM stdin;
1	default	normal	keeper	\N	2008-11-08 16:27:06.347692	2008-11-08 16:27:06.347692
\.


ALTER TABLE contracts ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

