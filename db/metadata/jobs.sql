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
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE jobs DISABLE TRIGGER ALL;

COPY jobs (id, name, description, income_stream_id, wc_category_id, program_id, virtual, effective_on, ineffective_on, offsite, reason_cannot_log_hours, fully_covered) FROM stdin;
56	Close	\N	\N	4	8	f	\N	\N	f	\N	f
138	Spanish Build Admin		13	7	2	f	\N	\N	f	\N	f
78	Mac Build		14	4	3	f	\N	\N	f	\N	f
151	Prebuild Admin		19	7	2	f	\N	\N	f	\N	f
154	Bulk Sales		21	4	4	f	\N	\N	f	\N	f
153	Distro Interns		23	7	9	f	\N	\N	f	\N	f
152	Paid Break		23	4	17	f	\N	\N	f	\N	f
155	Tills	Distribute fresh tills to the cashier posts in the morning.	23	7	8	f	\N	\N	f	\N	f
156	General Admin		23	7	8	f	\N	\N	f	\N	f
0	0 unavailable 0		23	9	17	t	\N	\N	f	\N	f
157	Laptops Eval		22	4	2	f	\N	\N	f	\N	f
125	Floor Work		\N	4	10	f	\N	\N	f	\N	f
63	Facilities Maintenance		\N	4	8	f	\N	\N	f	\N	f
13	Supply Check		\N	7	8	f	\N	\N	f	\N	f
142	Strategic Planning		\N	7	8	f	\N	\N	f	\N	f
108	Mtg Prep		\N	7	10	f	\N	\N	f	\N	f
116	Office Work		\N	7	10	f	\N	\N	f	\N	f
76	Bookkeeping		\N	7	8	f	\N	\N	f	\N	f
71	Education Coordination		\N	7	14	f	\N	\N	f	\N	f
122	Librarian		\N	7	5	f	\N	\N	f	\N	f
136	NPA Admin		\N	7	9	f	\N	\N	f	\N	f
121	Phone Work	Telephone system maintenance such as changing messages, configuring voice mail boxes, etc.	\N	7	8	f	\N	\N	f	\N	f
118	Meeting		\N	7	10	f	\N	\N	f	\N	f
117	Training	Training	\N	4	16	f	\N	\N	f	\N	f
129	Payroll	Calling in hours, entering payroll into books, distributing checks, retirement, BOL report	\N	7	8	f	\N	\N	f	\N	f
59	Grants	Hardware grant shepherding	\N	7	4	f	\N	\N	f	\N	f
141	Union bargaining	Meetings to negotiate contracts between union representatives and management.	\N	7	8	f	\N	\N	f	\N	f
119	Data Entry		\N	7	8	f	\N	\N	f	\N	f
102	Meet and Greet	Get volunteers from the front door to their stations and see how they're doing.	\N	7	5	f	\N	\N	f	\N	f
69	Reply to eMails		\N	7	8	f	\N	\N	f	\N	f
40	Bean Counting		\N	7	8	f	\N	\N	f	\N	f
14	Coding & Sysadmin		\N	7	10	f	\N	\N	f	\N	f
137	Truck Deliveries 	Taking the truck to places to drop stuff off	\N	5	11	f	\N	\N	f	\N	f
120	HR Admin	HR Administrative tasks that need to be done outside of the regular HR meeting	\N	7	8	f	\N	\N	f	\N	f
130	Weekly Reconciling	Reconciling the safe and/or other accounts on a weekly basis.	\N	7	8	f	\N	\N	f	\N	f
37	Supply Run		\N	4	8	f	\N	\N	f	\N	f
36	Feeding Loki	Going to the bank	\N	7	8	f	\N	\N	f	\N	f
28	Scheduling		\N	7	8	f	\N	\N	f	\N	f
131	Accounting	Development of new accounts in books for audit purposes, etc. Reconciling of major accounts. Documentation of accounting practices.	\N	7	8	f	\N	\N	f	\N	f
143	Security	Investigating crimes, dealing with police, etc.	\N	7	8	f	\N	\N	f	\N	f
132	Monthly Close Out	Closing out the month. Making sure all accounts are caught up, all accounts reconciled. Checking for plausibility of numbers.	\N	7	8	f	\N	\N	f	\N	f
124	Sales Admin		\N	7	4	f	\N	\N	f	\N	f
111	Safari	elephant hunting	\N	6	4	f	\N	\N	f	\N	f
101	Adoption Supplies	Stock the adoption class supplies.	\N	7	1	f	\N	\N	f	\N	f
135	Thrift Store Admin	Non floor related Thrift Store tasks	\N	7	4	f	\N	\N	f	\N	f
103	Volunteer Program Projects	Volunteer intern coordination, outreach to new volunteer pools, corresponding with volunteers, documentation, etc.	\N	7	16	f	\N	\N	f	\N	f
23	CommandLine	\N	\N	7	14	f	\N	\N	f	\N	f
79	Food Run		\N	4	16	f	\N	\N	f	\N	f
31	Advanced Linux	\N	\N	7	14	f	\N	\N	f	\N	f
66	Inreach Projects		\N	7	16	f	\N	\N	f	\N	f
133	Volunteer Appreciation		\N	4	16	f	\N	\N	f	\N	f
104	Outreach Projects		\N	7	7	f	\N	\N	f	\N	f
107	Institutional Outreach		\N	7	4	f	\N	\N	f	\N	f
127	Event Floorwork		\N	4	7	f	\N	\N	f	\N	f
126	Event Planning		\N	7	7	f	\N	\N	f	\N	f
112	Documentation		\N	7	15	f	\N	\N	f	\N	f
134	Inventory	Counting gizmos at the end of each month.	\N	4	11	f	\N	\N	f	\N	f
41	Office Coordination	Filing, establishing systems, etc.	\N	7	10	f	\N	\N	f	\N	f
105	Action Tasks		\N	4	10	f	\N	\N	f	\N	f
65	Free Computers!	\N	\N	4	4	f	\N	\N	f	\N	f
123	PR Admin		\N	7	7	f	\N	\N	f	\N	f
109	Intergalactic		\N	7	15	f	\N	\N	f	\N	f
128	Interviews		\N	7	10	f	\N	\N	f	\N	f
16	Thrift Store		\N	4	4	f	\N	\N	f	\N	f
106	Laptops Admin		22	7	2	f	\N	\N	f	\N	f
113	Printers Admin	All the stuff you need to do with printers that\r\nyou can't do when on printer shifts	15	6	1	f	\N	\N	f	\N	f
110	Tech walk thru		\N	4	8	f	\N	\N	f	\N	f
39	Recycling Coordination		19	7	11	f	\N	\N	f	\N	f
6	Teaching	Adoption and advanced adoption teaching.	\N	7	14	f	\N	\N	f	\N	f
139	Spanish Prebuild		19	6	2	f	\N	\N	f	\N	f
100	Tour Guide	Orient prospective volunteers and other interested people to Free Geek.	\N	4	14	f	\N	\N	f	\N	f
74	Group volunteers		\N	4	16	f	\N	\N	f	\N	f
148	Community Service		\N	7	16	f	\N	\N	f	\N	f
32	Build	\N	13	4	2	f	\N	\N	f	\N	f
144	Build Admin		13	7	4	f	\N	\N	f	\N	f
140	Spanish Build		13	4	2	f	\N	\N	f	\N	f
145	Mac Build Admin		14	4	4	f	\N	\N	f	\N	f
35	Printers		15	6	1	f	\N	\N	f	\N	f
114	Server Build		16	4	3	f	\N	\N	f	\N	f
68	Online Sales		18	7	4	f	\N	\N	f	\N	f
5	Prebuild		19	6	2	f	\N	\N	f	\N	f
42	Receiving	Coordinate volunteers while receiving gizmos (Hardware Donations)	19	6	1	f	\N	\N	f	\N	f
3	Recycling		19	6	11	f	\N	\N	f	\N	f
4	Front Desk		20	7	16	f	\N	\N	f	\N	f
1	Production Coord		21	4	2	f	\N	\N	f	\N	f
115	Production Floater	Covering Build and Laptops, or Laptops and Advanced Testing or whatever at the same time.	21	4	2	f	\N	\N	f	\N	f
17	Tech Support		23	4	9	f	\N	\N	f	\N	f
55	Tech Support Admin		23	7	9	f	\N	\N	f	\N	f
150	PdOFLA		23	9	8	f	\N	\N	f	\N	f
147	Jury Duty		23	9	8	f	\N	\N	f	\N	f
146	Hardware Testing Admin		17	7	4	f	\N	\N	f	\N	f
77	Hardware Testing		17	6	3	f	\N	\N	f	\N	f
58	Store Stocking	Stocking items in the store	\N	4	4	f	\N	\N	f	\N	f
149	A/V		21	7	3	f	\N	\N	f	\N	f
2	Laptops		22	4	2	f	\N	\N	f	\N	f
70	Offsite Donations	\N	21	5	4	f	\N	\N	t	\N	f
\.


ALTER TABLE jobs ENABLE TRIGGER ALL;

--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobs_id_seq', 157, true);


--
-- PostgreSQL database dump complete
--

