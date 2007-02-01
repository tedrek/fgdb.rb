--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

--
-- Data for Name: gizmo_contexts_gizmo_typeattrs; Type: TABLE DATA; Schema: public; Owner: stillflame
--

ALTER TABLE gizmo_contexts_gizmo_typeattrs DISABLE TRIGGER ALL;

COPY gizmo_contexts_gizmo_typeattrs (gizmo_context_id, gizmo_typeattr_id, lock_version, updated_at, created_at, created_by, updated_by) FROM stdin;
2	14	0	2006-10-10 12:11:56-07	2006-10-10 12:11:56-07	1	1
2	15	0	2006-10-10 12:11:56-07	2006-10-10 12:11:56-07	1	1
2	17	0	2006-10-10 12:11:56-07	2006-10-10 12:11:56-07	1	1
\.


ALTER TABLE gizmo_contexts_gizmo_typeattrs ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

