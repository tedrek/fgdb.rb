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
-- Name: gizmo_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('gizmo_types_id_seq', 51, true);


--
-- Data for Name: gizmo_types; Type: TABLE DATA; Schema: public; Owner: -
--

ALTER TABLE gizmo_types DISABLE TRIGGER ALL;

COPY gizmo_types (id, description, parent_id, lock_version, updated_at, created_at, required_fee_cents, suggested_fee_cents, gizmo_category_id, name) FROM stdin;
46	Service Fee	\N	1	2008-05-30 22:30:58.699506	2007-12-11 17:41:55	100	0	4	service_fee
17	Schwag	\N	5	2008-05-30 22:30:58.685012	2006-11-11 19:39:41	0	0	4	schwag
35	Case	13	1	2008-05-30 22:30:58.597832	2007-01-10 15:47:37	0	0	4	case
45	Gift Cert	\N	1	2008-05-30 22:30:58.694651	2007-12-11 17:01:35	0	0	4	gift_cert
44	Television	1	1	2008-05-30 22:30:58.665457	2007-10-23 19:17:36	1000	0	4	television
27	Harddrive	43	5	2008-05-30 22:30:58.655773	2007-01-02 10:06:08	0	100	4	harddrive
29	Speakers	13	2	2008-05-30 22:30:58.578448	2007-01-02 10:07:34	0	100	4	speakers
42	Power supply	13	1	2008-05-30 22:30:58.626915	2007-04-24 17:36:24	0	0	4	power_supply
34	Sound Card	30	2	2008-05-30 22:30:58.592979	2007-01-02 11:50:48	0	0	4	sound_card
11	Scanner	13	2	2008-05-30 22:30:58.454222	2006-11-11 19:09:38	0	300	3	scanner
0	[root]	\N	1	2008-05-30 22:30:58.680052	2008-03-27 10:41:53.50475	0	0	4	root
14	UPS	13	2	2008-05-30 22:30:58.544425	2006-11-11 19:18:08	0	500	4	ups
20	Old Data Schwag	17	1	2008-05-30 22:30:58.539574	2006-12-30 15:02:32	0	0	4	old_data_schwag
2	LCD	1	4	2008-05-30 22:30:58.492476	2006-09-25 11:21:53	0	400	2	lcd
28	Modem	13	3	2008-05-30 22:30:58.675204	2007-01-02 10:06:36	0	200	4	modem
43	Drive	13	2	2008-05-30 22:30:58.636599	2007-08-22 14:03:55	0	100	4	drive
31	Miscellaneous	13	3	2008-05-30 22:30:58.631744	2007-01-02 10:09:22	0	100	4	miscellaneous
33	Video Card	30	3	2008-05-30 22:30:58.588091	2007-01-02 11:50:20	0	0	4	video_card
18	1337 lappy	6	3	2008-05-30 22:30:58.514456	2006-12-19 20:16:28	0	0	1	1337_lappy
13	Gizmo	\N	5	2008-05-30 22:30:58.689829	2006-11-11 19:16:03	0	0	4	gizmo
36	Net Device	13	2	2008-05-30 22:30:58.660627	2007-01-10 15:48:05	0	100	4	net_device
48	Fee Discount	\N	0	2008-07-25 21:48:34.757712	2008-07-25 21:48:34.757712	0	0	4	fee_discount
32	CD Burner	43	3	2008-05-30 22:30:58.650888	2007-01-02 11:36:02	0	0	4	cd_burner
25	Stereo System	13	2	2008-05-30 22:30:58.568755	2007-01-02 10:04:58	0	400	4	stereo_system
7	VCR	13	3	2008-05-30 22:30:58.549293	2006-11-11 19:08:37	0	300	4	vcr
40	Laptop parts	13	2	2008-05-30 22:30:58.6221	2007-04-24 17:33:43	0	0	4	laptop_parts
26	Telephone	13	2	2008-05-30 22:30:58.573576	2007-01-02 10:05:31	0	200	4	telephone
8	DVD Player	13	3	2008-05-30 22:30:58.554147	2006-11-11 19:08:52	0	300	4	dvd_player
4	System	13	7	2008-05-30 22:30:58.499747	2006-09-25 11:22:30	0	500	1	system
1	Monitor	13	8	2008-05-30 22:30:58.46632	2006-09-25 11:21:29	0	0	2	monitor
30	Card	13	2	2008-05-30 22:30:58.583279	2007-01-02 10:08:06	0	100	4	card
22	Keyboard	13	2	2008-05-30 22:30:58.559	2007-01-02 10:03:00	0	100	4	keyboard
41	RAM	13	1	2008-05-30 22:30:58.617271	2007-04-24 17:34:10	0	0	4	ram
38	Tuition	17	1	2008-05-30 22:30:58.607498	2007-01-17 14:35:51	0	0	4	tuition
6	Laptop	4	2	2008-05-30 22:30:58.509601	2006-11-11 19:05:26	0	400	1	laptop
21	Old Data CRT	1	1	2008-05-30 22:30:58.47611	2006-12-30 18:57:55	1000	0	2	old_data_crt
10	Printer	13	2	2008-05-30 22:30:58.45908	2006-11-11 19:09:26	0	400	3	printer
12	Fax Machine	13	2	2008-05-30 22:30:58.443885	2006-11-11 19:13:34	0	400	3	fax_machine
37	Cable	13	1	2008-05-30 22:30:58.602659	2007-01-10 15:48:42	0	0	4	cable
23	Mouse	13	2	2008-05-30 22:30:58.563893	2007-01-02 10:03:31	0	100	4	mouse
19	Old Data Gizmo	13	1	2008-05-30 22:30:58.534699	2006-12-30 15:01:16	0	0	4	old_data_gizmo
16	T-Shirt	17	2	2008-05-30 22:30:58.529744	2006-11-11 19:19:26	0	0	4	t-shirt
15	Sticker	17	2	2008-05-30 22:30:58.524829	2006-11-11 19:19:08	0	0	4	sticker
3	Old Fee CRT	1	4	2008-05-30 22:30:58.471207	2006-09-25 11:22:11	1000	0	2	old_crt
5	Old Fee Sys w/ monitor	1	5	2008-05-30 22:30:58.504698	2006-09-29 14:22:28	1000	0	1	old_sys_with_monitor
49	CRT	1	0	2008-10-10 22:42:44.86573	2008-10-10 22:42:44.86573	700	0	2	crt
50	Sys w/ monitor	1	0	2008-10-10 22:42:45.058719	2008-10-10 22:42:45.058719	700	0	1	sys_with_monitor
39	Mac	4	1	2008-05-30 22:30:58.612372	2007-04-19 17:26:22	0	0	1	mac
47	Old Data System	19	1	2008-05-30 22:30:58.670346	2008-03-11 18:26:39	0	500	1	old_data_system
51	Mac Part	13	0	\N	\N	0	0	4	mac_part
\.


ALTER TABLE gizmo_types ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

