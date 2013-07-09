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
-- Data for Name: defaults; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE defaults DISABLE TRIGGER ALL;

COPY defaults (id, name, value, lock_version, updated_at, created_at) FROM stdin;
3	tax id	Federal Tax I.D.  93-1292010	0	2007-04-16 14:16:07	2007-04-16 14:16:07
6	country	United States	0	2007-04-16 14:16:42	2007-04-16 14:16:42
4	address image	/images/hdr-address.gif	0	2007-04-16 14:16:41	2007-04-16 14:16:41
5	business id		0	2007-04-16 14:22:06	2007-04-16 14:22:06
7	contact info	addr: 1731 SE 10th Portland, OR 97214 tele: 503.232.9350 email: info@freegeek.org	0	2007-04-16 14:22:16	2007-04-16 14:22:16
2	state_or_province	OR	1	2007-04-16 14:33:55	2007-04-16 14:15:25
1	city	Portland	1	2007-04-16 14:34:29	2007-04-16 14:15:10
8	my_email_address	fgdb@freegeek.org	0	\N	\N
9	volunteer_reports_to	inreach@todo.freegeek.org	0	\N	\N
13	fully_covered_contact_covered_gizmo	-1	0	2008-12-22 09:00:53.770448	2008-12-22 09:00:53.770448
14	unfully_covered_contact_covered_gizmo	7	0	2008-12-22 09:00:53.78511	2008-12-22 09:00:53.78511
16	max_effective_hours	24.0	1	2009-05-15 23:53:59.595633	2009-05-02 17:10:41.606476
18	hours_for_discount	3.0	0	2009-10-02 22:40:22.47043	2009-10-02 22:40:22.47043
19	days_for_discount	31	0	2009-10-02 22:40:22.49443	2009-10-02 22:40:22.49443
22	storecredit_expire_after	2.years	0	2011-04-01 19:27:45.019369	2011-04-01 19:27:45.019369
20	scheduler_reports_to	schedule@freegeek.org	1	2010-02-06 15:43:58.191298	2010-02-06 15:43:58.191298
23	return_path	www-data@freegeek.org	0	\N	\N
24	staff_mailing_list	paidworkers@lists.freegeek.org	0	2011-11-23 11:12:15.144131	2011-11-23 11:12:15.144131
25	hr_mailing_list	hr@lists.freegeek.org	0	2011-11-23 11:12:19.568129	2011-11-23 11:12:19.568129
26	beancounters_mailing_list	beancounters@lists.freegeek.org	1	2011-11-23 11:12:40.827741	2011-11-23 11:12:23.696162
27	volskedj_shift_limit	2	0	2011-12-10 00:39:10.126446	2011-12-10 00:39:10.126446
28	noreply_address	noreply@freegeek.org	0	2011-12-17 02:49:30.770806	2011-12-17 02:49:30.770806
30	newsletter_subscription_address	e-newsletter-join@lists.freegeek.org	0	2012-03-09 18:42:28.20556	2012-03-09 18:42:28.20556
31	staff_hours_timeout	5.minutes.ago	0	2012-03-10 11:23:45.275158	2012-03-10 11:23:45.275158
32	inventory_lock_end	2012-03-31	2	2012-04-06 14:10:56.476756	2012-04-05 15:37:00.850874
33	raw_receipt_printer_default	zebra	0	2012-05-05 12:35:07.5138	2012-05-05 12:35:07.5138
34	raw_receipt_printer_regexp	^(zebra|zebtest|jzebra|fakezebra)$	0	2012-05-05 12:35:07.561619	2012-05-05 12:35:07.561619
29	staffsched_rollout_until	2012-05-19	32	2012-05-09 18:26:47.491639	2012-02-10 15:55:33.98969
12	coveredness_enabled	0	1	2012-05-11 13:02:28.546352	2008-12-22 09:00:53.614147
21	checksum_base	0123456789ABCDEF	2	2012-05-11 13:02:28.561298	2011-03-25 20:19:22.694195
15	is-pdx	false	1	2012-05-11 19:36:34.668356	2008-12-22 09:01:02.01784
35	meeting_minder_address	agendapoker@freegeek.org	0	2012-12-08 05:39:51.949967	2012-12-08 05:39:51.949967
36	discount_percentage_id_for_volunteer_discount	5	0	2012-12-08 05:39:56.815796	2012-12-08 05:39:56.815796
37	discount_name_id_for_volunteer_discount	5	0	2012-12-08 05:39:56.820669	2012-12-08 05:39:56.820669
38	coding_ticket_owner	ryan52	0	2012-12-08 05:39:56.893217	2012-12-08 05:39:56.893217
39	raw_receipt_account_regexp	store	0	2013-07-09 11:32:33.801471	2013-07-09 11:32:33.801471
40	freekbox_proc_expect	Intel(R) Core(TM)2 Duo	0	2013-07-09 11:42:18.918283	2013-07-09 11:42:18.918283
41	freekbox_ram_expect	1.0gb	0	2013-07-09 11:42:18.934282	2013-07-09 11:42:18.934282
42	freekbox_hd_min	120gb	0	2013-07-09 11:42:18.949407	2013-07-09 11:42:18.949407
43	freekbox_hd_max	160gb	0	2013-07-09 11:42:18.959161	2013-07-09 11:42:18.959161
\.


ALTER TABLE defaults ENABLE TRIGGER ALL;

--
-- Name: defaults_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('defaults_id_seq', 43, true);


--
-- PostgreSQL database dump complete
--

