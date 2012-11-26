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
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobs_id_seq', 157, true);


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE jobs DISABLE TRIGGER ALL;

COPY jobs (id, name, description, coverage_type_id, income_stream_id, wc_category_id, program_id, virtual, effective_on, ineffective_on) FROM stdin;
138	Spanish Build Admin		2	13	7	2	f	\N	\N
78	Mac Build		2	14	4	3	f	\N	\N
151	Prebuild Admin		4	19	7	2	f	\N	\N
154	Bulk Sales		4	21	4	4	f	\N	\N
153	Distro Interns		2	23	7	9	f	\N	\N
152	Paid Break		5	23	4	17	f	\N	\N
155	Tills	Distribute fresh tills to the cashier posts in the morning.	5	23	7	8	f	\N	\N
156	General Admin		4	23	7	8	f	\N	\N
0	0 unavailable 0		2	23	9	17	t	\N	\N
157	Laptops Eval		2	22	4	2	f	\N	\N
125	Floor Work		2	\N	4	10	f	\N	\N
63	Facilities Maintenance		2	\N	4	8	f	\N	\N
13	Supply Check		2	\N	7	8	f	\N	\N
142	Strategic Planning		2	\N	7	8	f	\N	\N
108	Mtg Prep		2	\N	7	10	f	\N	\N
116	Office Work		2	\N	7	10	f	\N	\N
76	Bookkeeping		2	\N	7	8	f	\N	\N
71	Education Coordination		2	\N	7	14	f	\N	\N
122	Librarian		2	\N	7	5	f	\N	\N
136	NPA Admin		2	\N	7	9	f	\N	\N
121	Phone Work	Telephone system maintenance such as changing messages, configuring voice mail boxes, etc.	2	\N	7	8	f	\N	\N
118	Meeting		2	\N	7	10	f	\N	\N
117	Training	Training	2	\N	4	16	f	\N	\N
129	Payroll	Calling in hours, entering payroll into books, distributing checks, retirement, BOL report	2	\N	7	8	f	\N	\N
59	Grants	Hardware grant shepherding	2	\N	7	4	f	\N	\N
141	Union bargaining	Meetings to negotiate contracts between union representatives and management.	2	\N	7	8	f	\N	\N
119	Data Entry		2	\N	7	8	f	\N	\N
102	Meet and Greet	Get volunteers from the front door to their stations and see how they're doing.	2	\N	7	5	f	\N	\N
69	Reply to eMails		2	\N	7	8	f	\N	\N
40	Bean Counting		2	\N	7	8	f	\N	\N
14	Coding & Sysadmin		2	\N	7	10	f	\N	\N
137	Truck Deliveries 	Taking the truck to places to drop stuff off	2	\N	5	11	f	\N	\N
120	HR Admin	HR Administrative tasks that need to be done outside of the regular HR meeting	2	\N	7	8	f	\N	\N
130	Weekly Reconciling	Reconciling the safe and/or other accounts on a weekly basis.	2	\N	7	8	f	\N	\N
37	Supply Run		2	\N	4	8	f	\N	\N
36	Feeding Loki	Going to the bank	2	\N	7	8	f	\N	\N
28	Scheduling		2	\N	7	8	f	\N	\N
131	Accounting	Development of new accounts in books for audit purposes, etc. Reconciling of major accounts. Documentation of accounting practices.	2	\N	7	8	f	\N	\N
56	Close	\N	2	\N	4	8	f	\N	\N
143	Security	Investigating crimes, dealing with police, etc.	2	\N	7	8	f	\N	\N
132	Monthly Close Out	Closing out the month. Making sure all accounts are caught up, all accounts reconciled. Checking for plausibility of numbers.	2	\N	7	8	f	\N	\N
124	Sales Admin		2	\N	7	4	f	\N	\N
111	Safari	elephant hunting	2	\N	6	4	f	\N	\N
101	Adoption Supplies	Stock the adoption class supplies.	2	\N	7	1	f	\N	\N
135	Thrift Store Admin	Non floor related Thrift Store tasks	2	\N	7	4	f	\N	\N
103	Volunteer Program Projects	Volunteer intern coordination, outreach to new volunteer pools, corresponding with volunteers, documentation, etc.	2	\N	7	16	f	\N	\N
23	CommandLine	\N	2	\N	7	14	f	\N	\N
79	Food Run		2	\N	4	16	f	\N	\N
31	Advanced Linux	\N	2	\N	7	14	f	\N	\N
66	Inreach Projects		2	\N	7	16	f	\N	\N
133	Volunteer Appreciation		2	\N	4	16	f	\N	\N
104	Outreach Projects		2	\N	7	7	f	\N	\N
107	Institutional Outreach		2	\N	7	4	f	\N	\N
127	Event Floorwork		2	\N	4	7	f	\N	\N
126	Event Planning		2	\N	7	7	f	\N	\N
112	Documentation		2	\N	7	15	f	\N	\N
134	Inventory	Counting gizmos at the end of each month.	2	\N	4	11	f	\N	\N
41	Office Coordination	Filing, establishing systems, etc.	2	\N	7	10	f	\N	\N
105	Action Tasks		2	\N	4	10	f	\N	\N
65	Free Computers!	\N	2	\N	4	4	f	\N	\N
123	PR Admin		2	\N	7	7	f	\N	\N
109	Intergalactic		2	\N	7	15	f	\N	\N
128	Interviews		2	\N	7	10	f	\N	\N
16	Thrift Store		1	\N	4	4	f	\N	\N
106	Laptops Admin		2	22	7	2	f	\N	\N
113	Printers Admin	All the stuff you need to do with printers that\r\nyou can't do when on printer shifts	2	15	6	1	f	\N	\N
110	Tech walk thru		2	\N	4	8	f	\N	\N
39	Recycling Coordination		2	19	7	11	f	\N	\N
6	Teaching	Adoption and advanced adoption teaching.	2	\N	7	14	f	\N	\N
139	Spanish Prebuild		2	19	6	2	f	\N	\N
100	Tour Guide	Orient prospective volunteers and other interested people to Free Geek.	2	\N	4	14	f	\N	\N
74	Group volunteers		2	\N	4	16	f	\N	\N
148	Community Service		2	\N	7	16	f	\N	\N
32	Build	\N	1	13	4	2	f	\N	\N
144	Build Admin		2	13	7	4	f	\N	\N
140	Spanish Build		2	13	4	2	f	\N	\N
145	Mac Build Admin		2	14	4	4	f	\N	\N
35	Printers		2	15	6	1	f	\N	\N
114	Server Build		2	16	4	3	f	\N	\N
68	Online Sales		2	18	7	4	f	\N	\N
5	Prebuild		1	19	6	2	f	\N	\N
42	Receiving	Coordinate volunteers while receiving gizmos (Hardware Donations)	1	19	6	1	f	\N	\N
3	Recycling		1	19	6	11	f	\N	\N
4	Front Desk		1	20	7	16	f	\N	\N
70	Offsite Donations	\N	2	21	5	4	f	\N	\N
1	Production Coord		2	21	4	2	f	\N	\N
115	Production Floater	Covering Build and Laptops, or Laptops and Advanced Testing or whatever at the same time.	2	21	4	2	f	\N	\N
17	Tech Support		2	23	4	9	f	\N	\N
55	Tech Support Admin		2	23	7	9	f	\N	\N
150	PdOFLA		2	23	9	8	f	\N	\N
147	Jury Duty		2	23	9	8	f	\N	\N
146	Hardware Testing Admin		2	17	7	4	f	\N	\N
77	Hardware Testing		2	17	6	3	f	\N	\N
58	Store Stocking	Stocking items in the store	2	\N	4	4	f	\N	\N
149	A/V		2	21	7	3	f	\N	\N
2	Laptops		1	22	4	2	f	\N	\N
\.


ALTER TABLE jobs ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

