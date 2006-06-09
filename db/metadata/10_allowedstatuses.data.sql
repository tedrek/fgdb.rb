--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'fgdb';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 515369)
-- Name: allowedstatuses; Type: TABLE DATA; Schema: public; Owner: fgdb
--

COPY allowedstatuses (id, oldstatus, newstatus) FROM stdin;
1	Adopted	Cloned
2	Adopted	ForSale
3	Adopted	GAPped
4	Adopted	Granted
5	Adopted	Infrastructure
6	Adopted	Received
7	Adopted	Recycled
8	Adopted	Sold
9	Adopted	Stored
10	Cloned	Adopted
11	Cloned	ForSale
12	Cloned	GAPped
13	Cloned	Granted
14	Cloned	Infrastructure
15	Cloned	Received
16	Cloned	Recycled
17	Cloned	Sold
18	Cloned	Stored
19	ForSale	Adopted
20	ForSale	Cloned
21	ForSale	GAPped
22	ForSale	Granted
23	ForSale	Infrastructure
24	ForSale	Received
25	ForSale	Recycled
26	ForSale	Sold
27	ForSale	Stored
28	GAPped	Adopted
29	GAPped	Cloned
30	GAPped	ForSale
31	GAPped	Granted
32	GAPped	Infrastructure
33	GAPped	Received
34	GAPped	Recycled
35	GAPped	Sold
36	GAPped	Stored
37	Granted	Adopted
38	Granted	Cloned
39	Granted	ForSale
40	Granted	GAPped
41	Granted	Infrastructure
42	Granted	Received
43	Granted	Recycled
44	Granted	Sold
45	Granted	Stored
46	Infrastructure	Adopted
47	Infrastructure	Cloned
48	Infrastructure	ForSale
49	Infrastructure	GAPped
50	Infrastructure	Granted
51	Infrastructure	Received
52	Infrastructure	Recycled
53	Infrastructure	Sold
54	Infrastructure	Stored
55	Received	Adopted
56	Received	Cloned
57	Received	ForSale
58	Received	GAPped
59	Received	Granted
60	Received	Infrastructure
61	Received	Recycled
62	Received	Sold
63	Received	Stored
64	Recycled	Adopted
65	Recycled	Cloned
66	Recycled	ForSale
67	Recycled	GAPped
68	Recycled	Granted
69	Recycled	Infrastructure
70	Recycled	Received
71	Recycled	Sold
72	Recycled	Stored
73	Sold	Adopted
74	Sold	Cloned
75	Sold	ForSale
76	Sold	GAPped
77	Sold	Granted
78	Sold	Infrastructure
79	Sold	Received
80	Sold	Recycled
81	Sold	Stored
82	Stored	Adopted
83	Stored	Cloned
84	Stored	ForSale
85	Stored	GAPped
86	Stored	Granted
87	Stored	Infrastructure
88	Stored	Received
89	Stored	Recycled
90	Stored	Sold
91	Adopted	Refurbished
92	Cloned	Refurbished
93	ForSale	Refurbished
94	GAPped	Refurbished
95	Granted	Refurbished
96	Infrastructure	Refurbished
97	Received	Refurbished
98	Recycled	Refurbished
99	Sold	Refurbished
100	Stored	Refurbished
101	Refurbished	Adopted
102	Refurbished	Cloned
103	Refurbished	ForSale
104	Refurbished	GAPped
105	Refurbished	Granted
106	Refurbished	Infrastructure
107	Refurbished	Received
108	Refurbished	Recycled
109	Refurbished	Sold
110	Refurbished	Stored
111	Adopted	SoldOnline
112	Cloned	SoldOnline
113	ForSale	SoldOnline
114	GAPped	SoldOnline
115	Granted	SoldOnline
116	Infrastructure	SoldOnline
117	Received	SoldOnline
118	Recycled	SoldOnline
119	Sold	SoldOnline
120	Refurbished	SoldOnline
121	Stored	SoldOnline
122	SoldOnline	Adopted
123	SoldOnline	Cloned
124	SoldOnline	ForSale
125	SoldOnline	GAPped
126	SoldOnline	Granted
127	SoldOnline	Infrastructure
128	SoldOnline	Received
129	SoldOnline	Recycled
130	SoldOnline	Sold
131	SoldOnline	Stored
132	SoldOnline	Refurbished
\.


