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
-- Data for Name: gizmo_contexts_gizmo_types; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE gizmo_contexts_gizmo_types DISABLE TRIGGER ALL;

COPY gizmo_contexts_gizmo_types (gizmo_context_id, gizmo_type_id) FROM stdin;
1	2
1	3
3	3
4	3
1	4
2	4
4	4
1	5
3	5
1	6
2	6
3	6
4	6
1	10
2	10
3	10
4	10
1	11
2	11
3	11
4	11
2	2
3	2
4	2
1	12
3	12
4	12
3	4
1	14
2	14
3	14
4	14
1	22
2	22
1	23
2	23
1	26
2	27
1	29
2	29
1	30
2	30
1	31
2	32
2	35
2	36
2	37
2	39
4	39
2	40
2	41
2	42
4	31
1	43
1	36
1	44
3	44
1	46
4	49
1	49
3	49
2	49
4	50
1	50
3	50
2	50
1	42
1	54
1	58
1	60
2	60
1	41
1	27
4	5
4	22
4	23
4	27
4	29
4	30
4	32
4	36
4	41
4	54
4	56
4	58
4	59
4	60
1	32
1	55
1	56
1	57
1	59
1	61
1	62
2	44
2	52
2	54
2	55
2	56
2	57
2	58
2	61
2	62
2	63
2	17
2	65
2	66
2	67
2	68
2	72
1	39
1	74
1	75
1	76
2	74
2	75
2	76
3	39
3	74
3	55
3	54
3	75
3	76
4	44
4	74
4	55
4	75
4	76
5	39
5	6
5	4
5	44
5	49
5	50
5	74
5	55
5	2
5	54
5	75
5	76
2	45
2	79
2	80
2	81
2	82
2	83
2	84
2	59
3	59
1	85
2	85
2	86
2	88
2	89
1	89
1	90
4	90
3	90
2	90
5	90
2	92
2	93
2	94
2	95
2	96
2	97
2	98
2	99
2	100
1	101
1	102
1	103
\.


ALTER TABLE gizmo_contexts_gizmo_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

