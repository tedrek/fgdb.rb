--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'fgdb';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 514928)
-- Name: links; Type: TABLE DATA; Schema: public; Owner: fgdb
--

COPY links (id, modified, url, helptext, linktext, broken, howto, "external") FROM stdin;
1	2004-01-28 14:31:14-08				N	N	N
2	2004-01-28 15:16:29-08	reception/	Instructions for Receptionists	Front Desk Docs	N	Y	N
3	2004-04-09 12:20:23-07	donations/DonationProcessor.php	Donations	Donations	N	N	N
4	2004-04-09 12:22:14-07	sales/SaleProcessor.php	Sales	Sales	N	N	N
5	2004-01-28 15:17:09-08	deadtrees/	Forms	Forms	N	Y	N
6	2004-01-28 15:17:09-08	contact/ContactManager.php	Contacts	Contacts	N	N	N
7	2004-01-28 15:17:09-08	hours/	Volunteer Hours	Volunteer Hours	N	N	N
8	2004-01-28 15:17:09-08	syscheckout/syscheckout.php	Checkout&nbsp;Script	Checkout Script	N	N	N
10	2004-01-28 15:17:09-08	reports/members/inSystem.php	Current&nbsp;Adopters	Current Adopters	N	N	N
11	2004-01-28 15:17:09-08	reports/members/buildersReport.php	Current&nbsp;Builders	Current Builders	N	N	N
12	2004-01-28 15:17:09-08	reports/members/waitingList.php	Waiting&nbsp;List	Waiting List	N	N	N
13	2004-01-28 15:17:09-08	reports/members/happyList.php	Happy&nbsp;List	Happy List	N	N	N
14	2004-01-28 15:17:09-08	reports/donations/donationRptChoose.php	Donation&nbsp;Reports	Donation Reports	N	N	N
15	2004-01-28 15:40:21-08		More Reports	More Reports	Y	N	N
16	2004-01-28 15:17:09-08	scratchpad.php	Scratchpad	Scratchpad	N	N	N
17	2004-01-28 15:17:09-08	receiving/careandfeed.html	Care&nbsp;and&nbsp;Feeding	Care&nbsp;and&nbsp;Feeding	N	Y	N
18	2004-01-28 15:17:09-08	macrecycling.html	Mac&nbsp;Recycling	Mac&nbsp;Recycling	Y	Y	N
19	2004-01-28 15:17:09-08	receiving/gizmocloner.html	Cloner&nbsp;Howto	Cloner&nbsp;Howto	N	Y	N
20	2004-01-28 15:17:09-08	receiving/	Other&nbsp;Docs	Other&nbsp;Docs	N	Y	N
21	2004-01-28 15:17:09-08	gizmo/intake.php?action=lookupstart	Find&nbsp;Gizmo	Find&nbsp;Gizmo	N	N	N
22	2004-05-27 17:16:24-07	gizmo/intake.php?action=select_type	New&nbsp;Gizmo	New&nbsp;Gizmo	N	N	N
23	2004-01-28 15:17:09-08	deadtrees/receivingform.ps	Receiving&nbsp;Tickets	Receiving&nbsp;Tickets	N	Y	N
24	2004-01-28 15:17:09-08	gizmo/clone.php	Cloner	Cloner	N	N	N
25	2004-01-28 15:17:09-08		Reports	Reports	Y	N	N
26	2004-01-28 15:17:09-08	testing/	Testing&nbsp;Docs	Testing&nbsp;Docs	N	Y	N
27	2004-01-28 15:40:21-08		Reports	Reports	Y	N	N
28	2004-01-28 15:17:09-08	evaluation/	Sys&nbsp;Eval&nbsp;Docs	Sys&nbsp;Eval&nbsp;Docs	N	Y	N
29	2004-01-28 15:17:09-08	deadtrees/evalkeeptally.ps	Keeper&nbsp;Tally	Keeper&nbsp;Tally	N	Y	N
30	2004-01-28 15:17:09-08	deadtrees/evalrecycletally.ps	Recycle&nbsp;Tally	Recycle&nbsp;Tally	N	Y	N
31	2004-01-28 15:40:21-08		Reports	Reports	Y	N	N
32	2004-01-28 15:17:09-08	building/	Build&nbsp;Docs	Build&nbsp;Docs	N	Y	N
33	2004-01-28 15:40:21-08		Builder&nbsp;Login	Builder&nbsp;Login	Y	N	N
34	2004-01-28 15:40:21-08		Quality&nbsp;Control	Quality&nbsp;Control	Y	N	N
35	2004-01-28 15:40:21-08		System&nbsp;Tracking	System&nbsp;Tracking	Y	N	N
36	2004-01-28 15:17:09-08	http://lists.freegeek.org/listinfo/hardware	Hardware&nbsp;List	Hardware&nbsp;List	Y	N	Y
37	2004-01-28 15:40:21-08	reports/system/system-report.php	System&nbsp;Report	System&nbsp;Report	N	N	N
38	2004-01-28 15:40:21-08		Other&nbsp;Report	Other&nbsp;Report	Y	N	N
39	2004-01-28 15:17:09-08	printers/	Printer&nbsp;Docs	Printer&nbsp;Docs	N	Y	N
40	2004-01-28 15:17:09-08	http://www.linuxprinting.org	Linux&nbsp;Printing	Linux&nbsp;Printing	N	N	Y
41	2004-01-28 15:17:09-08	http://www.sane-project.org	SANE	SANE	N	N	Y
42	2004-01-28 15:17:09-08	http://localhost:631	CUPS	CUPS	N	N	Y
43	2004-01-28 15:40:21-08		Report	Other&nbsp;Report	Y	N	N
44	2004-01-28 15:17:09-08	receiving/boxocards.html	Box&nbsp;o'Cards&nbsp;Howto	Box&nbsp;o'Cards&nbsp;Howto	N	Y	N
45	2004-01-28 15:17:09-08	receiving/gizmocloner.html	Cloner&nbsp;Howto	Cloner&nbsp;Howto	N	Y	N
46	2004-01-28 15:17:09-08	receiving/	Other&nbsp;Docs	Other&nbsp;Docs	N	Y	N
47	2004-01-28 15:17:09-08	file:///usr/local/freekbox/start.html	FB&nbsp;Start&nbsp;Page	FB&nbsp;Start&nbsp;Page	N	N	Y
48	2004-01-28 15:17:09-08		Reports	Reports	Y	N	N
49	2004-01-28 15:17:09-08	http://freegeek.org/adopters/faq.html	FAQ	FAQ	Y	Y	N
50	2004-01-28 15:17:09-08	support/	Other&nbsp;Docs	Other&nbsp;Docs	Y	N	Y
51	2004-05-25 12:47:52-07	http://freegeek.org/adopters/	Adopters'&nbsp;Page	Adopters'&nbsp;Page	N	N	Y
52	2004-01-28 15:17:09-08	sales/	Sales&nbsp;Docs	Sales&nbsp;Docs	Y	N	Y
53	2004-01-28 15:40:21-08	sales/SaleProcessor.php	Sales&nbsp;Receipts	Sales&nbsp;Receipts	N	N	N
54	2004-01-28 15:17:09-08	http://www.ebay.com	Search&nbsp;eBay	Search&nbsp;eBay	N	N	Y
56	2004-01-28 15:40:21-08		More&nbsp;Reports	More&nbsp;Reports	Y	N	N
57	2004-01-28 15:17:09-08	recycling/	Other&nbsp;Docs	Other&nbsp;Docs	N	Y	N
58	2004-01-28 15:40:21-08		Pickups	Pickups	Y	N	N
59	2004-01-28 15:40:21-08		Pickup&nbsp;Reports	Pickup&nbsp;Reports	Y	N	N
60	2004-01-28 15:40:21-08		Other&nbsp;Reports	Other&nbsp;Reports	Y	N	N
61	2004-01-28 15:40:21-08		Enter&nbsp;Income	Enter&nbsp;Income	Y	N	N
62	2004-01-28 15:40:21-08		Resource&nbsp;Tracking	Resource&nbsp;Tracking	Y	N	N
63	2004-01-28 15:40:21-08		Sort&nbsp;Names	Sort&nbsp;Names	N	N	N
64	2004-01-28 15:40:21-08		Contact&nbsp;Lists	Contact&nbsp;Lists	Y	N	N
65	2004-01-28 15:40:21-08	reports/volunteers/vol-reports-1.php	Volunteer&nbsp;Reports	Volunteer&nbsp;Reports	N	N	N
66	2004-01-28 15:40:21-08	reports/gizmos/gizmo-reports-1.php	Gizmo&nbsp;Reports	Gizmo&nbsp;Reports	N	N	N
67	2004-01-28 15:40:21-08		Intake&nbsp;Lookup	Intake&nbsp;Lookup	Y	N	N
68	2004-01-28 15:40:21-08	reports/office.php	Other&nbsp;Reports	Other&nbsp;Reports	N	N	N
69	2004-01-28 15:17:09-08	http://lists.freegeek.org/listinfo/freekbox	FreekBox&nbsp;List	FreekBox&nbsp;List	N	N	Y
70	2004-01-28 15:17:09-08	http://lists.freegeek.org/listinfo/support	Support&nbsp;List	Support&nbsp;List	N	N	Y
71	2004-01-28 15:17:09-08	reports/support	Reports	Reports	N	N	N
72	2004-01-28 15:17:09-08	frontdesk.php	Front&nbsp;Desk	Front&nbsp;Desk	N	N	N
73	2004-01-28 15:17:09-08	receiving.php	Receiving	Receiving	N	N	N
74	2004-01-28 15:17:09-08	testing.php	Testing	Testing	N	N	N
75	2004-01-28 15:17:09-08	evaluation.php	System&nbsp;Eval	System&nbsp;Eval	N	N	N
76	2004-01-28 15:17:09-08	build.php	Build	Build	N	N	N
77	2004-01-28 15:17:09-08	printers.php	Printers	Printers	N	N	N
78	2004-01-28 15:17:09-08	lab.php	Lab	Lab	N	N	N
79	2004-01-28 15:17:09-08	support.php	Tech&nbsp;Support	Tech&nbsp;Support	N	N	N
80	2004-01-28 15:17:09-08	store.php	Store	Store	N	N	N
81	2004-01-28 15:17:09-08	recycling.php	Recycling	Recycling	N	N	N
82	2004-01-28 15:17:09-08	office.php	Office	Office	N	N	N
83	2004-03-03 11:50:49-08	sched/enterID.php	Staff&nbsp;Hours	Staff&nbsp;Hours	N	N	N
84	2004-03-03 11:50:49-08	sched/sched.php?SHOWNUMS=1	Staff&nbsp;Schedule	Staff&nbsp;Schedule	N	N	N
55	2004-01-28 15:40:21-08	reports/sales/salesRptChoose.php	Sales&nbsp;Reports	Sales&nbsp;Reports	N	N	N
9	2004-06-09 16:11:18-07	reports/misc/incomeRptChoose.php	Daily&nbsp;Totals	Daily&nbsp;Totals	N	N	N
\.


