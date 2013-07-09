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
-- Data for Name: spec_sheet_questions; Type: TABLE DATA; Schema: public; Owner: -
--

SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE spec_sheet_questions DISABLE TRIGGER ALL;

COPY spec_sheet_questions (id, name, question, created_at, updated_at, "position") FROM stdin;
1	Case	Is it a tower or a rack-mount?	\N	2012-12-08 05:39:52.290214	0
2	Height in Rack Units	How many rack units (u) is it?	\N	2012-12-08 05:39:52.293827	1
3	Maximum Power Supplies	How many power supplies can it hold?	\N	2012-12-08 05:39:52.297062	2
4	Current Power Supplies	How many power supplies are present?	\N	2012-12-08 05:39:52.300264	3
5	Maximum Processors	How many processors can it hold?	\N	2012-12-08 05:39:52.303542	4
6	Current Processors	How many processors are present?	\N	2012-12-08 05:39:52.307706	5
7	Maximum Hard Drives	How many hard drives can it hold?	\N	2012-12-08 05:39:52.310968	7
8	Current Hard Drives	How many hard drives are present?	\N	2012-12-08 05:39:52.369034	8
9	Hardware Raid Support	Does it support hardware raid?	\N	2012-12-08 05:39:52.372735	9
10	Software Raid Support	Does it support software raid?	\N	2012-12-08 05:39:52.37622	10
11	Boot Setup Key	What is the BIOS key to enter setup during boot?	2012-03-09 11:22:21.243839	2012-12-08 05:39:52.379818	11
12	Boot Device Menu Key	What is the BIOS key to select a boot device? (or 'N/A', if none applies)	2012-03-17 01:17:54.511748	2012-12-08 05:39:52.384184	12
13	Network Boot Key	What is the BIOS key to boot to the network, if any?	2012-03-17 01:17:54.603267	2012-12-08 05:39:52.387859	13
14	RAM Type	What is the type and speed of the RAM it uses?	2012-03-31 00:37:35.694249	2012-12-08 05:39:52.391589	14
15	Wireless	Is the system using a PCMCIA (External) or PCI Wireless Card?	2012-03-31 00:37:35.769895	2012-12-08 05:39:52.39506	15
16	Has Wireless Switch	Is there a physical switch to toggle the Wireless on/off?	2012-03-31 00:37:35.780613	2012-12-08 05:39:52.398622	16
17	Wireless Switch Location	Describe the relative location of the switch (e.g., Above keyboard, right side of chassis near optical drive, etc)	2012-03-31 00:37:35.791772	2012-12-08 05:39:52.40223	17
18	Has Wireless Key Combo	Is there a keyboard combination to toggle the Wireless on/off?	2012-03-31 00:37:35.806742	2012-12-08 05:39:52.405773	18
19	Wireless Key Combination	Enter the key combination (e.g., Fn + F2)	2012-03-31 00:37:35.817879	2012-12-08 05:39:52.409921	19
20	Power Adapter Rating	What is the rating for the power adapter included with this system?\nPlease include voltage and amperage (e.g., 19.5V 3.42A)	2012-03-31 00:37:35.832751	2012-12-08 05:39:52.413346	20
21	Cores per Processor	How many cores does each processors have?	2012-12-08 05:39:52.123319	2012-12-08 05:39:52.417442	6
22	DIMM Type	What type of DIMMs are the installed RAM sticks? (Registered, ECC, FB-DIMM, etc.)	2012-12-08 05:39:52.256816	2012-12-08 05:39:52.421771	21
\.


ALTER TABLE spec_sheet_questions ENABLE TRIGGER ALL;

--
-- Name: spec_sheet_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('spec_sheet_questions_id_seq', 22, true);


--
-- PostgreSQL database dump complete
--

