--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'SQL_ASCII';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('jobs_id_seq', 148, true);


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE jobs DISABLE TRIGGER ALL;

COPY jobs (id, name, description, coverage_type_id, income_stream_id, wc_category_id, program_id, virtual) FROM stdin;
0	0 unavailable 0	\N	2	1	\N	8	t
125	Floor Work		1	12	4	10	f
63	Facilities Maintenance		3	1	4	8	f
13	Supply Check		3	1	7	8	f
106	Laptop Admin		5	5	7	2	f
1	Production Coord		3	5	4	2	f
110	Tech walk thru		5	1	4	8	f
77	Advanced Testing	\N	3	5	6	3	f
6	Teaching	Adoption and advanced adoption teaching.	2	4	7	14	f
3	Recycling		1	2	6	11	f
139	Spanish Prebuild		1	2	6	12	f
100	Tour Guide	Orient prospective volunteers and other interested people to Free Geek.	2	4	4	14	f
147	Jury Duty		1	\N	\N	4	f
74	Group volunteers		5	4	4	16	f
148	Community Service		1	4	7	16	f
32	Build	\N	2	5	4	2	f
138	Spanish Build Admin		1	5	7	2	f
142	Strategic Planning		5	1	7	8	f
108	Mtg Prep		5	12	7	10	f
116	Office Work		4	1	7	10	f
78	Mac Build		3	5	4	3	f
146	Advanced Testing Admin		1	5	7	4	f
76	Bookkeeping		4	1	7	8	f
71	Education Coordination		5	4	7	14	f
122	Librarian		1	4	7	5	f
136	NPA Admin		1	4	7	9	f
17	Tech Support	\N	2	4	4	2	f
121	Phone Work	Telephone system maintenance such as changing messages, configuring voice mail boxes, etc.	1	1	7	8	f
113	Printer Admin	All the stuff you need to do with printers that\r\nyou can't do when on printer shifts	4	2	6	1	f
58	Floater and Stocking		3	12	4	4	f
118	Meeting		2	12	7	10	f
117	Training	Training	1	12	4	16	f
129	Payroll	Calling in hours, entering payroll into books, distributing checks, retirement, BOL report	1	1	7	8	f
59	Grants	Hardware grant shepherding	5	6	7	4	f
42	Receiving	Coordinate volunteers while receiving gizmos (Hardware Donations)	1	2	6	1	f
141	Union bargaining	Meetings to negotiate contracts between union representatives and management.	1	1	7	8	f
119	Data Entry		1	1	7	8	f
2	Laptops	\N	2	5	4	2	f
102	Meet and Greet	Get volunteers from the front door to their stations and see how they're doing.	2	4	7	5	f
69	Reply to eMails		5	6	7	8	f
40	Bean Counting		4	1	7	8	f
14	Coding & Sysadmin		4	1	7	10	f
137	Truck Deliveries 	Taking the truck to places to drop stuff off	1	1	5	11	f
120	HR Admin	HR Administrative tasks that need to be done outside of the regular HR meeting	1	1	7	8	f
130	Weekly Reconciling	Reconciling the safe and/or other accounts on a weekly basis.	1	1	7	8	f
37	Supply Run		3	1	4	8	f
36	Feeding Loki	Going to the bank	4	1	7	8	f
28	Scheduling		4	1	7	8	f
131	Accounting	Development of new accounts in books for audit purposes, etc. Reconciling of major accounts. Documentation of accounting practices.	1	1	7	8	f
56	Close	\N	2	1	4	8	f
143	Security	Investigating crimes, dealing with police, etc.	1	1	7	8	f
132	Monthly Close Out	Closing out the month. Making sure all accounts are caught up, all accounts reconciled. Checking for plausibility of numbers.	1	1	7	8	f
124	Sales Admin		1	3	7	4	f
111	Safari	elephant hunting	1	3	6	4	f
39	Recycling Coordination		5	2	7	11	f
5	Prebuild		1	2	6	2	f
35	Printers		3	2	6	1	f
101	Adoption Supplies	Stock the adoption class supplies.	4	4	7	1	f
135	Thrift Store Admin	Non floor related Thrift Store tasks	4	3	7	4	f
16	Thrift Store		1	3	4	4	f
68	Online Sales		4	3	7	4	f
103	Volunteer Program Projects	Volunteer intern coordination, outreach to new volunteer pools, corresponding with volunteers, documentation, etc.	5	4	7	16	f
55	Tech Support Admin	\N	2	4	7	2	f
4	Front Desk		1	4	7	16	f
23	CommandLine	\N	2	4	7	14	f
79	Food Run		3	4	4	16	f
31	Advanced Linux	\N	2	4	7	14	f
66	Inreach Projects		2	4	7	16	f
133	Volunteer Appreciation		1	4	4	16	f
104	Outreach Projects		5	6	7	7	f
115	Production Floater	Covering Build and Laptops, or Laptops and Advanced Testing or whatever at the same time.	1	5	4	2	f
107	Institutional Outreach		4	6	7	4	f
114	Server Build		1	5	4	3	f
145	Mac Build Admin		1	5	4	4	f
127	Event Floorwork		1	6	4	7	f
126	Event Planning		1	6	7	7	f
70	Offsite Donations	\N	2	6	5	4	f
112	Documentation		1	12	7	15	f
134	Inventory	Counting gizmos at the end of each month.	2	1	4	11	f
41	Office Coordination	Filing, establishing systems, etc.	5	12	7	10	f
140	Spanish Build		1	5	4	2	f
144	Build Admin		1	5	7	4	f
105	Action Tasks		5	12	4	10	f
65	Free Computers!	\N	2	6	4	4	f
123	PR Admin		1	6	7	7	f
109	Intergalactic		5	6	7	15	f
128	Interviews		1	12	7	10	f
\.


ALTER TABLE jobs ENABLE TRIGGER ALL;

--
-- PostgreSQL database dump complete
--

