--
-- Selected TOC Entries:
--

DROP SEQUENCE "allowedstatuses_id_seq" ;
DROP TABLE "allowedstatuses" ;
DROP SEQUENCE "classtree_id_seq" ;
DROP TABLE "classtree" ;
DROP SEQUENCE "codedinfo_id_seq" ;
DROP TABLE "codedinfo" ;
DROP TRIGGER "codedinfo_created_trigger" ;
DROP TRIGGER "codedinfo_modified_trigger" ;
DROP SEQUENCE "defaultvalues_id_seq" ;
DROP TABLE "defaultvalues" ;
DROP SEQUENCE "fieldmap_id_seq" ;
DROP TABLE "fieldmap" ;
DROP SEQUENCE "holidays_id_seq" ;
DROP TABLE "holidays" ;
DROP TRIGGER "holidays_created_trigger" ;
DROP TRIGGER "holidays_modified_trigger" ;
DROP SEQUENCE "links_id_seq" ;
DROP TABLE "links" ;
DROP SEQUENCE "pagelinks_id_seq" ;
DROP TABLE "pagelinks" ;
DROP SEQUENCE "pages_id_seq" ;
DROP TABLE "pages" ;
DROP TRIGGER "pages_created_trigger" ;
DROP TRIGGER "pages_modified_trigger" ;
DROP SEQUENCE "relations_id_seq" ;
DROP TABLE "relations" ;

--
-- TOC Entry ID 2 (OID 1484527)
--
-- Name: allowedstatuses_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "allowedstatuses_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485306)
--
-- Name: allowedstatuses Type: TABLE Owner: fgdb
--

CREATE TABLE "allowedstatuses" (
	"id" integer DEFAULT nextval('allowedStatuses_id_seq'::text) NOT NULL,
	"oldstatus" character varying(15),
	"newstatus" character varying(15),
	Constraint "allowedstatuses_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485306)
--
-- Name: allowedstatuses Type: TABLE DATA Owner: fgdb
--


COPY "allowedstatuses" FROM stdin;
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
\.
--
-- TOC Entry ID 3 (OID 1484527)
--
-- Name: allowedstatuses_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"allowedstatuses_id_seq"', 110, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484533)
--
-- Name: classtree_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "classtree_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485315)
--
-- Name: classtree Type: TABLE Owner: fgdb
--

CREATE TABLE "classtree" (
	"id" integer DEFAULT nextval('classTree_id_seq'::text) NOT NULL,
	"classtree" character varying(100),
	"tablename" character varying(50),
	"level" integer,
	"instantiable" character varying(1) DEFAULT 'Y' NOT NULL,
	"intakecode" character varying(10),
	"intakeadd" integer,
	"description" character varying(50),
	CONSTRAINT "classtree_instantiable" CHECK (((instantiable = 'N'::"varchar") OR (instantiable = 'Y'::"varchar"))),
	Constraint "classtree_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485315)
--
-- Name: classtree Type: TABLE DATA Owner: fgdb
--


COPY "classtree" FROM stdin;
1	Gizmo	Gizmo	1	N	\N	0	Gizmo
2	Gizmo.Component	Component	2	N	\N	0	Component
4	Gizmo.Component.Card.MiscCard	MiscCard	4	Y	MISCCARD	0	Miscellaneous Card
5	Gizmo.Component.Card.ModemCard	ModemCard	4	Y	MODEMCARD	0	Regular Internal Modem
6	Gizmo.Component.Card.NetworkCard	NetworkCard	4	Y	NETWORKCAR	0	Network Card
7	Gizmo.Component.Card.SCSICard	SCSICard	4	Y	SCSICARD	0	SCSI Card
8	Gizmo.Component.Card.SoundCard	SoundCard	4	Y	SOUNDCARD	0	Sound Card
9	Gizmo.Component.Card.VideoCard	VideoCard	4	Y	VIDEOCARD	0	Video Card
10	Gizmo.Component.Card.ControllerCard	ControllerCard	4	Y	CONTROLLER	0	I/O or Controller Card
11	Gizmo.Component.SystemCase	SystemCase	4	Y	SYSTEMCASE	0	System Case
13	Gizmo.Component.Drive	Drive	3	N	\N	0	Drive
14	Gizmo.Component.Drive.CDDrive	CDDrive	4	Y	CDDRIVE	0	CD Drive
16	Gizmo.Component.Drive.FloppyDrive	FloppyDrive	4	Y	FLOPPYDRIV	0	Floppy Drive
17	Gizmo.Component.Drive.IDEHardDrive	IDEHardDrive	4	Y	IDEHARDDRI	0	Regular IDE Hard Drive
18	Gizmo.Component.Drive.MiscDrive	MiscDrive	4	Y	MISCDRIVE	0	Miscellaneous Drive
19	Gizmo.Component.Drive.SCSIHardDrive	SCSIHardDrive	4	Y	SCSIHARDDR	0	SCSI Hard Drive
20	Gizmo.Component.Drive.TapeDrive	TapeDrive	4	Y	TAPEDRIVE	0	Tape Drive
21	Gizmo.Component.Keyboard	Keyboard	3	Y	KEYBOARD	0	Keyboard
22	Gizmo.Component.MiscComponent	MiscComponent	3	Y	MISCCOMPON	0	Miscellaneous Component
23	Gizmo.Component.Modem	Modem	3	Y	MODEM	0	External Modem
24	Gizmo.Component.Monitor	Monitor	3	Y	MONITOR	0	Monitor
25	Gizmo.Component.PointingDevice	PointingDevice	3	Y	POINTINGDE	0	Mouse or other Pointing Device
26	Gizmo.Component.PowerSupply	PowerSupply	3	Y	POWERSUPPL	0	Power Supply
27	Gizmo.Component.Printer	Printer	3	Y	PRINTER	0	Printer
28	Gizmo.Component.Processor	Processor	3	Y	PROCESSOR	0	Processor
30	Gizmo.Component.Scanner	Scanner	3	Y	SCANNER	0	Scanner
31	Gizmo.Component.Speaker	Speaker	3	Y	SPEAKER	0	Speaker
32	Gizmo.Component.SystemBoard	SystemBoard	3	Y	SYSTEMBOAR	0	Motherboard (System Mainboard)
36	Gizmo.NetworkingDevice	NetworkingDevice	2	Y	NETWORKING	0	Networking Device
34	Gizmo.MiscGizmo	MiscGizmo	2	Y	MISCGIZMO	0	Miscellaneous Gizmo
35	Gizmo.System	System	2	Y	\N	0	System
3	Gizmo.Component.Card	Card	3	N	\N	0	Card
37	Gizmo.Laptop	Laptop	2	Y	\N	0	System
\.
--
-- TOC Entry ID 3 (OID 1484533)
--
-- Name: classtree_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"classtree_id_seq"', 37, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484535)
--
-- Name: codedinfo_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "codedinfo_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485318)
--
-- Name: codedinfo Type: TABLE Owner: fgdb
--

CREATE TABLE "codedinfo" (
	"id" integer DEFAULT nextval('codedInfo_id_seq'::text) NOT NULL,
	"codetype" character varying(100),
	"codelength" integer DEFAULT '10',
	"code" character varying(25),
	"description" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "codedinfo_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485318)
--
-- Name: codedinfo Type: TABLE DATA Owner: fgdb
--


COPY "codedinfo" FROM stdin;
1	CDDrive.interface	10	IDE	IDE	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
2	CDDrive.interface	10	OTHER	OTHER	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
3	CDDrive.speed	10	2x	2x	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
4	CDDrive.speed	10	4x	4x	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
5	CDDrive.speed	10	52x	52x	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
6	CDDrive.writeMode	10	Writeable	Writeable	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
7	CDDrive.writeMode	10	ReWriteable	ReWriteable	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
8	CDDrive.writeMode	10	Play	Play	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
9	Card.slotType	10	AGP	AGP	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
15	Card.slotType	10	PCI	PCI	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
16	Card.slotType	10	ISA	ISA	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
17	Card.slotType	10	EISA	EISA	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
18	Card.slotType	10	VESA	VESA	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
19	Card.slotType	10	OTHER	OTHER	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
20	SystemCase.caseType	10	FullTower	FullTower	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
21	SystemCase.caseType	10	MidTower	MidTower	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
22	SystemCase.caseType	10	MiniTower	MiniTower	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
23	SystemCase.caseType	10	Desktop	Desktop	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
24	SystemCase.caseType	10	Portable	Portable	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
25	SystemCase.caseType	10	Laptop	Laptop	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
26	Coprocessor.chipType	10	487	487	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
27	Coprocessor.chipType	10	387	387	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
28	FloppyDrive.diskSize	10	3.5in	3.5in	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
29	FloppyDrive.diskSize	10	5.25in	5.25in	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
30	FloppyDrive.capacity	10	360k	360k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
31	FloppyDrive.capacity	10	700k	700k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
32	FloppyDrive.capacity	10	1.44mb	1.44mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
33	FloppyDrive.capacity	10	720k	720k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
34	FloppyDrive.capacity	10	1.22mb	1.22mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
35	Gizmo.architecture	10	PC	PC	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
36	Gizmo.architecture	10	MAC	MAC	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
37	Gizmo.architecture	10	MULTI	MULTI	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
38	Gizmo.architecture	10	OTHER	OTHER	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
39	Keyboard.kbType	10	PS2	PS2	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
40	Keyboard.kbType	10	AT	AT	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
215	MemberHour.jobType	15	Receiving	Receiving	2003-02-06 11:15:47-08	2000-11-20 18:54:35-08
42	Keyboard.kbType	10	USB	USB	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
43	Keyboard.numKeys	10	101	101	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
44	Keyboard.numKeys	10	102	102	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
45	Keyboard.numKeys	10	104	104	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
46	Keyboard.numKeys	10	124	124	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
47	Modem.speed	10	14.4	14.4	2002-10-09 15:19:50-07	2001-08-23 18:08:05-07
48	Modem.speed	10	28.8	28.8	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
49	Modem.speed	10	33.6	33.6	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
50	Modem.speed	10	56k	56k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
51	Modem.speed	10	ISDN	ISDN	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
52	Modem.speed	10	CABLE	CABLE	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
53	ModemCard.speed	10	14.4	14.4	2002-10-09 15:19:50-07	2001-08-23 18:08:05-07
54	ModemCard.speed	10	28.8	28.8	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
55	ModemCard.speed	10	33.6	33.6	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
56	ModemCard.speed	10	56k	56k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
57	ModemCard.speed	10	ISDN	ISDN	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
58	ModemCard.speed	10	CABLE	CABLE	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
59	Monitor.size	10	12	12	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
60	Monitor.size	10	13	13	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
61	Monitor.size	10	14	14	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
62	Monitor.size	10	15	15	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
63	Monitor.size	10	17	17	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
64	Monitor.size	10	19	19	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
65	Monitor.size	10	21	21	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
66	Monitor.resolution	10	800	 800x600	2002-10-09 15:19:50-07	2001-03-14 19:15:21-08
67	Monitor.resolution	10	1024	1024x768	2002-10-09 15:19:50-07	2001-03-14 16:24:34-08
70	NetworkCard.speed	10	10	10	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
71	NetworkCard.speed	10	100	100	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
72	NetworkCard.speed	10	14	14	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
189	CDDrive.speed	10	8x	8x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
188	CDDrive.speed	10	6x	6x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
187	CDDrive.speed	10	1x	1x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
76	PointingDevice.connector	10	PS2	PS2	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
77	PointingDevice.connector	10	USB	USB	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
78	PointingDevice.connector	10	DB9	DB9	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
79	PointingDevice.pointerType	10	Mouse	Mouse	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
80	PointingDevice.pointerType	10	Trackball	Trackball	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
81	PointingDevice.pointerType	10	Tablet	Tablet	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
82	PointingDevice.pointerType	10	Pen	Pen	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
83	PointingDevice.pointerType	10	Oddball	Oddball	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
84	PowerSupply.connection	10	AT	AT	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
85	PowerSupply.connection	10	ATX	ATX	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
86	Printer.printerType	10	DotMatrix	DotMatrix	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
87	Printer.printerType	10	Laser	Laser	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
88	Printer.printerType	10	Jet	Jet	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
89	Printer.interface	10	SCSI	SCSI	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
90	Printer.interface	10	Parallel	Parallel	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
91	Processor.chipClass	10	386	386	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
92	Processor.chipClass	10	486	486	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
93	Processor.chipClass	10	Pentium	Pentium	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
94	Processor.chipClass	10	MMX	MMX	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
95	Processor.chipClass	10	PRO	PRO	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
96	Processor.chipClass	10	PII	PII	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
97	Processor.chipClass	10	PIII	PIII	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
98	Processor.chipClass	10	AMD K6	AMD K6	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
99	Processor.chipClass	10	AMD Athalon	AMD Athalon	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
100	Processor.interface	10	socket	socket	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
101	Processor.interface	10	slot	slot	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
102	RAM.pins	10	31	31	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
103	RAM.pins	10	72	72	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
104	RAM.pins	10	168	168	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
105	RAM.size	10	1mb	1mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
106	RAM.size	10	2mb	2mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
107	RAM.size	10	4mb	4mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
108	RAM.size	10	8mb	8mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
109	RAM.size	10	16mb	16mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
110	RAM.size	10	32mb	32mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
111	RAM.size	10	64mb	64mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
112	RAM.size	10	128mb	128mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
113	RAM.size	10	512mb	512mb	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
114	RAM.speed	10	80ns	80ns	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
115	RAM.speed	10	70ns	70ns	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
116	RAM.speed	10	60ns	60ns	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
117	RAM.speed	10	pc100	pc100	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
118	RAM.speed	10	pc133	pc133	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
119	RAM.speed	10	RDRAM	RDRAM	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
120	RAM.speed	10	800mhz	800mhz	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
121	SCSICard.internalInterface	10	SCSI1_2_fast	SCSI1_2_fast	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
122	SCSICard.internalInterface	10	Wide	Wide	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
123	SCSICard.internalInterface	10	IDE	IDE	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
124	SCSICard.internalInterface	10	Floppy	Floppy	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
125	SCSICard.externalInterface	10	db25	db25	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
126	SCSICard.externalInterface	10	hd50	hd50	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
127	SCSICard.externalInterface	10	hd68	hd68	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
128	SCSIHardDrive.scsiVersion	10	1	1	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
129	SCSIHardDrive.scsiVersion	10	2	2	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
130	SCSIHardDrive.scsiVersion	10	F	F	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
131	SCSIHardDrive.scsiVersion	10	W	W	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
132	SCSIHardDrive.scsiVersion	10	FW	FW	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
133	SCSIHardDrive.scsiVersion	10	Ultra	Ultra	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
134	SCSIHardDrive.scsiVersion	10	160	160	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
145	Scanner.interface	10	SCSI	SCSI	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
146	Scanner.interface	10	Parallel	Parallel	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
147	SoundCard.soundType	10	SB/compatible	SB/compatible	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
148	SoundCard.soundType	10	other	other	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
149	TapeDrive.interface	10	IDE	IDE	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
150	TapeDrive.interface	10	SCSI	SCSI	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
151	TapeDrive.interface	10	Proprietary	Proprietary	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
152	VideoCard.videoMemory	10	512k	512k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
153	VideoCard.videoMemory	10	1024k	1024k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
154	VideoCard.videoMemory	10	2040k	2040k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
155	VideoCard.videoMemory	10	4096k	4096k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
156	VideoCard.videoMemory	10	8192k	8192k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
157	VideoCard.videoMemory	10	16384k	16384k	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
158	VideoCard.videoMemory	10	more	more	2002-10-09 15:19:50-07	2000-09-29 09:00:59-07
240	System.chipClass	10	AMD K6	AMD K6	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
239	System.chipClass	10	PIII	PIII	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
238	System.chipClass	10	PII	PII	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
237	System.chipClass	10	PRO	PRO	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
234	System.chipClass	10	486	486	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
236	System.chipClass	10	MMX	MMX	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
256	Gizmo.newStatus	15	Cloned	Cloned	2002-10-09 15:19:50-07	2001-06-14 16:02:40-07
235	System.chipClass	10	Pentium	Pentium	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
233	System.chipClass	10	386	386	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
174	Gizmo.newStatus	15	Sold	Sold	2002-10-09 15:19:50-07	2000-12-20 09:59:29-08
258	Gizmo.oldStatus	15	Sold	Sold	2002-10-09 15:19:50-07	2001-06-14 16:02:40-07
257	Gizmo.oldStatus	15	Cloned	Cloned	2002-10-09 15:19:50-07	2001-06-14 16:02:40-07
179	IDEHardDrive.ata	10	33	33	2002-10-09 15:19:50-07	2000-10-03 09:02:48-07
180	IDEHardDrive.ata	10	66	66	2002-10-09 15:19:50-07	2000-10-03 09:03:00-07
181	IDEHardDrive.ata	10	100	100	2002-10-09 15:19:50-07	2000-10-03 09:03:08-07
182	SystemBoard.dimmSpeed	10	PC133	PC133	2002-10-09 15:19:50-07	2000-10-03 09:04:03-07
183	SystemBoard.dimmSpeed	10	PC100	PC100	2002-10-09 15:19:50-07	2000-10-03 09:04:11-07
184	SystemBoard.dimmSpeed	10	PC800	PC800	2002-10-09 15:19:50-07	2000-10-03 09:04:18-07
185	Keyboard.kbType	10	ADB	ADB	2002-10-09 15:19:50-07	2000-10-13 02:24:30-07
186	PointingDevice.connector	10	ADB	ADB	2002-10-09 15:19:50-07	2000-10-13 02:25:19-07
190	CDDrive.speed	10	10x	10x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
191	CDDrive.speed	10	12x	12x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
192	CDDrive.speed	10	14x	14x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
193	CDDrive.speed	10	16x	16x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
194	CDDrive.speed	10	18x	18x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
195	CDDrive.speed	10	20x	20x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
196	CDDrive.speed	10	22x	22x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
197	CDDrive.speed	10	24x	24x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
198	CDDrive.speed	10	26x	26x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
199	CDDrive.speed	10	28x	28x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
200	CDDrive.speed	10	30x	30x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
201	CDDrive.speed	10	32x	32x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
202	CDDrive.speed	10	34x	34x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
203	CDDrive.speed	10	36x	36x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
204	CDDrive.speed	10	38x	38x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
205	CDDrive.speed	10	40x	40x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
206	CDDrive.speed	10	42x	42x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
207	CDDrive.speed	10	44x	44x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
208	CDDrive.speed	10	46x	46x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
209	CDDrive.speed	10	48x	48x	2002-10-09 15:19:50-07	2000-10-22 06:37:33-07
210	CDDrive.speed	10	50x	50x	2002-10-09 15:19:50-07	2000-10-22 06:39:59-07
211	CDDrive.speed	10	54x	54x	2002-10-09 15:19:50-07	2000-10-22 06:39:59-07
212	CDDrive.speed	10	56x	56x	2002-10-09 15:19:50-07	2000-10-22 06:39:59-07
213	CDDrive.speed	10	58x	58x	2002-10-09 15:19:50-07	2000-10-22 06:39:59-07
214	CDDrive.speed	10	60x	60x	2002-10-09 15:19:50-07	2000-10-22 06:39:59-07
216	MemberHour.jobType	15	Testing	Testing	2003-02-06 11:15:47-08	2000-11-20 18:54:35-08
262	MemberHour.jobType	15	SysAdmin	System Administration	2003-02-06 11:15:47-08	2001-09-28 19:46:00-07
218	MemberHour.jobType	15	Recycling	Recycling	2003-02-06 11:15:47-08	2000-11-20 18:54:35-08
219	MemberHour.jobType	15	Admin	General Administration	2003-02-06 11:15:47-08	2000-11-20 18:54:35-08
220	MemberHour.jobType	15	Misc	Misc	2003-02-06 11:15:47-08	2000-11-20 18:54:35-08
261	MemberHour.jobType	15	Education	Education	2003-02-06 11:15:47-08	2001-09-28 19:46:00-07
260	MemberHour.jobType	15	Build	Build: Assembly and Software	2003-12-10 15:26:20-08	2001-09-28 19:46:00-07
259	MemberHour.jobType	15	Support	Technical Support	2003-02-06 11:15:47-08	2001-09-28 19:46:00-07
224	Gizmo.newStatus	15	Received	Received	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
225	Gizmo.oldStatus	15	Received	Received	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
226	Gizmo.newStatus	15	Stored	Stored	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
227	Gizmo.oldStatus	15	Stored	Stored	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
228	Gizmo.newStatus	15	Adopted	Adopted	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
229	Gizmo.oldStatus	15	Adopted	Adopted	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
230	Gizmo.newStatus	15	Recycled	Recycled	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
231	Gizmo.oldStatus	15	Recycled	Recycled	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
241	System.chipClass	10	AMD Athlon	AMD Athlon	2002-10-09 15:19:50-07	2001-02-14 18:37:13-08
242	MemberHour.jobType	15	Adoption	Adoption	2003-02-06 11:15:47-08	2001-09-28 19:46:00-07
243	Printer.interface	10	Serial	Serial	2002-10-09 15:19:50-07	2001-03-14 16:20:26-08
245	Monitor.resolution	10	640	 640x480	2002-10-09 15:19:50-07	2001-03-14 19:16:11-08
246	Monitor.resolution	10	1280	1280x1024	2002-10-09 15:19:50-07	2001-03-14 19:14:00-08
247	Monitor.resolution	10	1600	1600x1200	2002-10-09 15:19:50-07	2001-03-14 16:27:52-08
248	Monitor.resolution	10	832	Mac:  832x624	2002-10-09 15:19:50-07	2001-03-14 19:16:44-08
249	Monitor.resolution	10	1152M	Mac: 1152x870	2002-10-09 15:19:50-07	2002-04-04 16:50:42-08
250	Printer.interface	10	USB	USB	2002-10-09 15:19:50-07	2001-05-31 09:12:25-07
251	Scanner.interface	10	USB	USB	2002-10-09 15:19:50-07	2001-05-31 09:12:33-07
252	Printer.interface	10	S/P	Serial/Parallel	2002-10-09 15:19:50-07	2001-05-31 09:23:43-07
253	PointingDevice.pointerType	10	Joystick	Joystick	2002-10-09 15:19:50-07	2001-05-31 15:34:24-07
254	Gizmo.newStatus	15	Infrastructure	FREE GEEK Infrasructure	2002-10-09 15:19:50-07	2001-06-09 17:35:39-07
255	Gizmo.oldStatus	15	Infrastructure	FREE GEEK Infrasructure	2002-10-09 15:19:50-07	2001-06-09 17:36:10-07
263	TapeDrive.Interface	10	Parallel	Parallel	2002-10-09 15:19:50-07	2001-10-05 18:59:11-07
264	Gizmo.oldStatus	15	ForSale	For Sale	2002-10-09 15:19:50-07	2002-01-26 11:39:32-08
265	Gizmo.newStatus	15	ForSale	For Sale	2002-10-09 15:19:50-07	2002-01-26 11:39:37-08
266	MemberHour.jobType	15	DataEntry	Data Entry	2003-02-06 11:15:47-08	2002-03-02 09:13:50-08
267	SalesLine.merchType	15	Gizmo	Gizmo	2002-10-09 15:19:50-07	2002-03-02 19:24:08-08
268	SalesLine.merchType	15	TShirt	T-Shirt	2002-10-09 15:19:50-07	2002-03-02 19:24:40-08
269	Printer.interface	10	ADB	ADB	2002-10-09 15:19:50-07	2002-04-23 18:30:40-07
270	MemberHour.jobType	15	Evaluation	Build: System Evaluation	2003-12-10 15:28:01-08	2002-10-09 15:19:16-07
271	MemberHour.jobType	15	Comp4Kids	Computers for Kids	2003-02-06 11:15:47-08	2002-11-15 15:32:46-08
273	MemberHour.jobType	15	Sales	Sales	2003-02-06 11:15:47-08	2002-11-15 15:32:46-08
276	ContactList.listName	20	Staff	Staff	2002-11-16 14:27:04-08	2002-11-16 14:25:20-08
274	MemberHour.jobType	15	Orientation	Orientation	2003-02-06 11:15:47-08	2002-11-15 15:34:58-08
275	MemberHour.jobType	15	Repair	Repair	2003-02-06 11:15:47-08	2002-11-15 15:35:48-08
277	ContactList.listName	20	ASS	ASS	2002-11-16 14:27:04-08	2002-11-16 14:25:25-08
278	ContactList.listName	20	Education	Education	2002-11-16 14:27:04-08	2002-11-16 14:25:32-08
279	ContactList.listName	20	SMS	SMS	2002-11-16 14:27:24-08	2002-11-16 14:27:21-08
280	MemberHour.jobType	15	Teaching	Teaching	2003-02-06 11:15:47-08	2003-02-06 11:15:47-08
281	MemberHour.jobType	15	Programming	Programming	2003-02-06 11:15:47-08	2003-02-06 11:15:47-08
282	MemberHour.jobType	15	CREAM	CREAM	2003-02-06 11:15:47-08	2003-02-06 11:15:47-08
283	Income.incomeType	20	Recycling	Recycling Income	2003-06-17 18:37:03-07	2003-06-17 18:37:03-07
284	Income.incomeType	20	Grants	Grant Income	2003-06-17 18:37:21-07	2003-06-17 18:37:21-07
285	Income.incomeType	20	Other	Miscellaneous Income	2003-06-17 18:37:38-07	2003-06-17 18:37:38-07
286	Income.incomeType	20	Online Donations	Online Donations	2003-06-24 13:31:30-07	2003-06-24 13:31:30-07
287	Income.incomeType	20	Online Sales	Online Sales	2003-06-24 13:31:39-07	2003-06-24 13:31:39-07
288	Income.incomeType	20	Consulting Income	Consulting Income	2003-06-24 13:32:10-07	2003-06-24 13:32:10-07
321	MemberHour.jobType	15	AdvancedTesting	Build: Advanced Testing	2004-04-08 14:13:53-07	2003-12-10 15:29:32-08
320	MemberHour.jobType	15	Quality	Build: Quality Control	2004-04-08 14:13:53-07	2003-12-10 15:27:43-08
318	ContactList.listName	20	Council		2004-04-08 14:13:53-07	2003-07-15 20:23:17-07
326	Gizmo.location	10	Lost	Lost	2004-04-09 14:26:56-07	2004-04-09 14:26:56-07
325	Gizmo.location	10	Borrowed	Borrowed	2004-04-09 14:26:45-07	2004-04-09 14:26:45-07
324	Gizmo.location	10	Free Geek	Free Geek	2004-04-09 14:26:13-07	2004-04-09 14:26:13-07
323	Gizmo.oldStatus	15	Granted	Granted	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
322	Gizmo.newStatus	15	Granted	Granted	2002-10-09 15:19:50-07	2000-12-28 01:10:55-08
319	System.chipClass	10	Celeron	Celeron	2004-04-08 14:13:53-07	2003-09-13 13:39:03-07
317	MemberHour.jobType	15	Sorting	Build: Card and Mobo Sorting	2004-04-08 14:13:53-07	2003-12-10 15:28:22-08
316	unitType	20	Gaylord	Gaylord	2004-04-08 14:13:53-07	2003-06-25 12:14:35-07
315	unitType	20	Pallet	Pallet	2004-04-08 14:13:53-07	2003-06-25 12:14:35-07
314	unitType	20	Dumpster	Dumpster	2004-04-08 14:13:53-07	2003-06-25 12:14:35-07
313	unitType	20	Bucket	Bucket	2004-04-08 14:13:53-07	2003-06-25 12:14:35-07
312	unitType	20	Piece	Piece	2004-04-08 14:13:53-07	2003-06-25 12:14:35-07
\.
--
-- TOC Entry ID 7 (OID 2417952)
--
-- Name: codedinfo_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "codedinfo_created_trigger" BEFORE INSERT ON "codedinfo"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 6 (OID 2417953)
--
-- Name: codedinfo_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "codedinfo_modified_trigger" BEFORE UPDATE ON "codedinfo"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 3 (OID 1484535)
--
-- Name: codedinfo_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"codedinfo_id_seq"', 326, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484537)
--
-- Name: defaultvalues_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "defaultvalues_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485324)
--
-- Name: defaultvalues Type: TABLE Owner: fgdb
--

CREATE TABLE "defaultvalues" (
	"id" integer DEFAULT nextval('defaultValues_id_seq'::text) NOT NULL,
	"classtree" character varying(100),
	"fieldname" character varying(50),
	"defaultvalue" character varying(50),
	Constraint "defaultvalues_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485324)
--
-- Name: defaultvalues Type: TABLE DATA Owner: fgdb
--


COPY "defaultvalues" FROM stdin;
1	Gizmo.Component.Card.MiscCard	newStatus	Received
2	Gizmo.Component.Card.ModemCard	newStatus	Received
3	Gizmo.Component.Card.NetworkCard	newStatus	Received
4	Gizmo.Component.Card.SCSICard	newStatus	Received
5	Gizmo.Component.Card.SoundCard	newStatus	Received
6	Gizmo.Component.Card.VideoCard	newStatus	Received
7	Gizmo.Component.Card.ControllerCard	newStatus	Received
8	Gizmo.Component.SystemCase	newStatus	Received
10	Gizmo.Component.Drive.CDDrive	newStatus	Received
12	Gizmo.Component.Drive.FloppyDrive	newStatus	Received
13	Gizmo.Component.Drive.IDEHardDrive	newStatus	Received
14	Gizmo.Component.Drive.MiscDrive	newStatus	Received
15	Gizmo.Component.Drive.SCSIHardDrive	newStatus	Received
16	Gizmo.Component.Drive.TapeDrive	newStatus	Received
17	Gizmo.Component.Keyboard	newStatus	Received
18	Gizmo.Component.MiscComponent	newStatus	Received
19	Gizmo.Component.Modem	newStatus	Received
20	Gizmo.Component.Monitor	newStatus	Received
21	Gizmo.Component.PointingDevice	newStatus	Received
22	Gizmo.Component.PowerSupply	newStatus	Received
23	Gizmo.Component.Printer	newStatus	Received
24	Gizmo.Component.Processor	newStatus	Received
26	Gizmo.Component.Scanner	newStatus	Received
27	Gizmo.Component.Speaker	newStatus	Received
28	Gizmo.Component.SystemBoard	newStatus	Received
39	Gizmo.NetworkingDevice	newStatus	Received
34	Gizmo.System	newStatus	Received
33	Gizmo.MiscGizmo	newStatus	Received
36	Gizmo.System	gizmoType	System
37	Gizmo.Component.Monitor	gizmoType	Monitor
38	Gizmo.Component.Printer	gizmoType	Printer
40	Gizmo.Laptop	newStatus	Received
41	Gizmo.Laptop	gizmoType	System
\.
--
-- TOC Entry ID 3 (OID 1484537)
--
-- Name: defaultvalues_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"defaultvalues_id_seq"', 41, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484539)
--
-- Name: fieldmap_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "fieldmap_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485327)
--
-- Name: fieldmap Type: TABLE Owner: fgdb
--

CREATE TABLE "fieldmap" (
	"id" integer DEFAULT nextval('fieldMap_id_seq'::text) NOT NULL,
	"tablename" character varying(50),
	"fieldname" character varying(50),
	"displayorder" integer DEFAULT '0' NOT NULL,
	"inputwidget" character varying(50),
	"inputwidgetparameters" character varying(100),
	"outputwidget" character varying(50),
	"outputwidgetparameters" character varying(100),
	"editable" character varying(1) DEFAULT 'Y',
	"helplink" character varying(1) DEFAULT 'N',
	"description" character varying(100),
	CONSTRAINT "fieldmap_editable" CHECK (((editable = 'N'::"varchar") OR (editable = 'Y'::"varchar"))),
	CONSTRAINT "fieldmap_helplink" CHECK (((helplink = 'N'::"varchar") OR (helplink = 'Y'::"varchar"))),
	Constraint "fieldmap_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485327)
--
-- Name: fieldmap Type: TABLE DATA Owner: fgdb
--


COPY "fieldmap" FROM stdin;
1	Gizmo	id	10	\N	\N	\N	\N	N	N	
2	Gizmo	classTree	20	\N	\N	\N	\N	N	N	
4	Gizmo	oldStatus	40	\N	\N	\N	\N	N	N	
5	Gizmo	newStatus	50	STATUSCHANGE	Gizmo.newStatus	\N	\N	Y	Y	
7	Gizmo	working	70	YNM	\N	\N	\N	Y	Y	Is Unit Working?
305	Gizmo	value	140	\N	\N	\N	\N	Y	Y	
11	Gizmo	architecture	80	DROPDOWN	Gizmo.architecture	\N	\N	Y	Y	
12	Gizmo	manufacturer	90	\N	\N	\N	\N	Y	Y	
13	Gizmo	modelNumber	100	\N	\N	\N	\N	Y	Y	
14	Gizmo	notes	110	\N	\N	\N	\N	Y	Y	
15	Gizmo	created	25	\N	\N	DATETIME	\N	N	N	
16	Gizmo	modified	24	\N	\N	DATETIME	\N	N	N	
17	Component	id	1	\N	\N	\N	\N	N	N	
18	Component	classTree	2	\N	\N	\N	\N	N	N	
19	Component	inSysId	3	\N	\N	\N	\N	Y	Y	
310	Gizmo	gizmoType	21	\N	\N	\N	\N	N	N	Type
22	Card	id	1	\N	\N	\N	\N	N	N	
23	Card	classTree	2	\N	\N	\N	\N	N	N	
30	Card	slotType	4	DROPDOWN	Card.slotType	\N	\N	Y	Y	
35	MiscCard	id	1	\N	\N	\N	\N	N	N	
36	MiscCard	classTree	2	\N	\N	\N	\N	N	N	
37	MiscCard	miscNotes	3	\N	\N	\N	\N	Y	Y	
38	ModemCard	id	1	\N	\N	\N	\N	N	N	
39	ModemCard	classTree	2	\N	\N	\N	\N	N	N	
40	ModemCard	speed	3	DROPDOWN	ModemCard.speed	\N	\N	Y	Y	
46	NetworkCard	id	1	\N	\N	\N	\N	N	N	
47	NetworkCard	classTree	2	\N	\N	\N	\N	N	N	
48	NetworkCard	speed	3	DROPDOWN	NetworkCard.speed	\N	\N	Y	Y	
54	SCSICard	id	1	\N	\N	\N	\N	N	N	
55	SCSICard	classTree	2	\N	\N	\N	\N	N	N	
56	SCSICard	internalInterface	3	DROPDOWN	SCSICard.internalInterface	\N	\N	Y	Y	
60	SCSICard	externalInterface	4	DROPDOWN	SCSICard.externalInterface	\N	\N	Y	Y	
63	SCSICard	parms	5	\N	\N	\N	\N	Y	Y	
64	SoundCard	id	1	\N	\N	\N	\N	N	N	
65	SoundCard	classTree	2	\N	\N	\N	\N	N	N	
66	SoundCard	soundType	3	DROPDOWN	SoundCard.soundType	\N	\N	Y	Y	
68	VideoCard	id	1	\N	\N	\N	\N	N	N	
69	VideoCard	classTree	2	\N	\N	\N	\N	N	N	
70	VideoCard	videoMemory	3	DROPDOWN	VideoCard.videoMemory	\N	\N	Y	Y	
75	VideoCard	resolutions	4	\N	\N	\N	\N	Y	Y	
76	ControllerCard	id	1	\N	\N	\N	\N	N	N	
77	ControllerCard	classTree	2	\N	\N	\N	\N	N	N	
78	ControllerCard	numSerial	3	\N	\N	\N	\N	Y	Y	
79	ControllerCard	numParallel	4	\N	\N	\N	\N	Y	Y	
80	ControllerCard	numIDE	5	\N	\N	\N	\N	Y	Y	
81	ControllerCard	floppy	6	TOGGLE	\N	\N	\N	Y	Y	
82	SystemCase	id	1	\N	\N	\N	\N	N	N	
83	SystemCase	classTree	2	\N	\N	\N	\N	N	N	
84	SystemCase	caseType	3	DROPDOWN	SystemCase.caseType	\N	\N	Y	Y	
90	Coprocessor	id	1	\N	\N	\N	\N	N	N	
91	Coprocessor	classTree	2	\N	\N	\N	\N	N	N	
92	Coprocessor	chipType	3	DROPDOWN	Coprocessor.chipType	\N	\N	Y	Y	
93	Coprocessor	chipType	3	DROPDOWN	Coprocessor.chipType	\N	\N	Y	Y	
94	Drive	id	1	\N	\N	\N	\N	N	N	
95	Drive	classTree	2	\N	\N	\N	\N	N	N	
96	CDDrive	id	1	\N	\N	\N	\N	N	N	
97	CDDrive	classTree	2	\N	\N	\N	\N	N	N	
98	CDDrive	interface	3	DROPDOWN	CDDrive.interface	\N	\N	Y	Y	
100	CDDrive	speed	4	DROPDOWN	CDDrive.speed	\N	\N	Y	Y	
103	CDDrive	writeMode	5	DROPDOWN	CDDrive.writeMode	\N	\N	Y	Y	
308	Gizmo	linuxfund	150	YNM	\N	\N	\N	Y	N	Publish to LinuxFund.org?
307	CDDrive	scsi	6	TOGGLE	\N	\N	\N	Y	Y	
118	FloppyDrive	id	1	\N	\N	\N	\N	N	N	
119	FloppyDrive	classTree	2	\N	\N	\N	\N	N	N	
120	FloppyDrive	diskSize	3	DROPDOWN	FloppyDrive.diskSize	\N	\N	Y	Y	
122	FloppyDrive	capacity	4	DROPDOWN	FloppyDrive.capacity	\N	\N	Y	Y	
127	FloppyDrive	cylinders	5	\N	\N	\N	\N	Y	Y	
128	FloppyDrive	heads	6	\N	\N	\N	\N	Y	Y	
129	FloppyDrive	sectors	7	\N	\N	\N	\N	Y	Y	
130	IDEHardDrive	id	1	\N	\N	\N	\N	N	N	
131	IDEHardDrive	classTree	2	\N	\N	\N	\N	N	N	
132	IDEHardDrive	cylinders	3	\N	\N	\N	\N	Y	Y	
133	IDEHardDrive	heads	4	\N	\N	\N	\N	Y	Y	
134	IDEHardDrive	sectors	5	\N	\N	\N	\N	Y	Y	
135	IDEHardDrive	sizeMb	6	\N	\N	\N	\N	Y	Y	
136	MiscDrive	id	1	\N	\N	\N	\N	N	N	
137	MiscDrive	classTree	2	\N	\N	\N	\N	N	N	
138	MiscDrive	miscNotes	3	\N	\N	\N	\N	Y	Y	
139	SCSIHardDrive	id	1	\N	\N	\N	\N	N	N	
140	SCSIHardDrive	classTree	2	\N	\N	\N	\N	N	N	
141	SCSIHardDrive	sizeMb	3	\N	\N	\N	\N	Y	Y	
142	SCSIHardDrive	scsiVersion	4	DROPDOWN	SCSIHardDrive.scsiVersion	\N	\N	Y	Y	
149	TapeDrive	id	1	\N	\N	\N	\N	N	N	
150	TapeDrive	classTree	2	\N	\N	\N	\N	N	N	
151	TapeDrive	interface	3	DROPDOWN	TapeDrive.interface	\N	\N	Y	Y	
154	Keyboard	id	1	\N	\N	\N	\N	N	N	
155	Keyboard	classTree	2	\N	\N	\N	\N	N	N	
156	Keyboard	kbType	3	DROPDOWN	Keyboard.kbType	\N	\N	Y	Y	
160	Keyboard	numKeys	4	DROPDOWN	Keyboard.numKeys	\N	\N	Y	Y	
164	MiscComponent	id	1	\N	\N	\N	\N	N	N	
165	MiscComponent	classTree	2	\N	\N	\N	\N	N	N	
166	MiscComponent	miscNotes	3	\N	\N	\N	\N	Y	Y	
167	Modem	id	1	\N	\N	\N	\N	N	N	
168	Modem	classTree	2	\N	\N	\N	\N	N	N	
169	Modem	speed	3	DROPDOWN	Modem.speed	\N	\N	Y	Y	
175	Monitor	id	1	\N	\N	\N	\N	N	N	
176	Monitor	classTree	2	\N	\N	\N	\N	N	N	
177	Monitor	size	3	DROPDOWN	Monitor.size	\N	\N	Y	Y	
184	Monitor	resolution	4	DROPDOWN	Monitor.resolution	\N	\N	Y	Y	
188	PointingDevice	id	1	\N	\N	\N	\N	N	N	
189	PointingDevice	classTree	2	\N	\N	\N	\N	N	N	
190	PointingDevice	connector	3	DROPDOWN	PointingDevice.connector	\N	\N	Y	Y	
193	PointingDevice	pointerType	4	DROPDOWN	PointingDevice.pointerType	\N	\N	Y	Y	
198	PowerSupply	id	1	\N	\N	\N	\N	N	N	
199	PowerSupply	classTree	2	\N	\N	\N	\N	N	N	
200	PowerSupply	watts	3	\N	\N	\N	\N	Y	Y	
201	PowerSupply	connection	4	DROPDOWN	PowerSupply.connection	\N	\N	Y	Y	
203	Printer	id	1	\N	\N	\N	\N	N	N	
204	Printer	classTree	2	\N	\N	\N	\N	N	N	
205	Printer	speedppm	3	\N	\N	\N	\N	Y	Y	
206	Printer	printerType	4	DROPDOWN	Printer.printerType	\N	\N	Y	Y	
209	Printer	interface	5	DROPDOWN	Printer.interface	\N	\N	Y	Y	
211	Processor	id	1	\N	\N	\N	\N	N	N	
212	Processor	classTree	2	\N	\N	\N	\N	N	N	
213	Processor	chipClass	3	DROPDOWN	Processor.chipClass	\N	\N	Y	Y	
222	Processor	interface	4	DROPDOWN	Processor.interface	\N	\N	Y	Y	
224	Processor	speed	5	\N	\N	\N	\N	Y	Y	
225	RAM	id	1	\N	\N	\N	\N	N	N	
226	RAM	classTree	2	\N	\N	\N	\N	N	N	
227	RAM	pins	3	DROPDOWN	RAM.pins	\N	\N	Y	Y	
230	RAM	size	4	DROPDOWN	RAM.size	\N	\N	Y	Y	
239	RAM	speed	5	DROPDOWN	RAM.speed	\N	\N	Y	Y	
246	Scanner	id	1	\N	\N	\N	\N	N	N	
247	Scanner	classTree	2	\N	\N	\N	\N	N	N	
248	Scanner	interface	3	DROPDOWN	Scanner.interface	\N	\N	Y	Y	
250	Speaker	id	1	\N	\N	\N	\N	N	N	
251	Speaker	classTree	2	\N	\N	\N	\N	N	N	
252	Speaker	powered	3	TOGGLE	\N	\N	\N	Y	Y	
253	Speaker	subwoofer	4	TOGGLE	\N	\N	\N	Y	Y	
254	SystemBoard	id	1	\N	\N	\N	\N	N	N	
255	SystemBoard	classTree	2	\N	\N	\N	\N	N	N	
311	NetworkingDevice	id	1	\N	\N	\N	\N	N	N	
258	MiscGizmo	id	1	\N	\N	\N	\N	N	N	
259	MiscGizmo	classTree	2	\N	\N	\N	\N	N	N	
260	System	id	1	\N	\N	\N	\N	N	N	
261	System	classTree	2	\N	\N	\N	\N	N	N	
262	System	systemConfiguration	30	\N	\N	\N	\N	N	N	
263	System	systemBoard	40	\N	\N	\N	\N	N	N	
264	System	adapterInformation	50	\N	\N	\N	\N	N	N	
265	System	multiprocessorInformation	60	\N	\N	\N	\N	N	N	
266	System	displayDetails	70	\N	\N	\N	\N	N	N	
267	System	displayInformation	80	\N	\N	\N	\N	N	N	
268	System	scsiInformation	90	\N	\N	\N	\N	N	N	
269	System	pcmciaInformation	100	\N	\N	\N	\N	N	N	
270	System	modemInformation	110	\N	\N	\N	\N	N	N	
271	System	multimediaInformation	120	\N	\N	\N	\N	N	N	
272	System	plugNplayInformation	130	\N	\N	\N	\N	N	N	
273	System	physicalDrives	140	\N	\N	\N	\N	N	N	
278	Gizmo	testData	120	TOGGLE	\N	\N	\N	Y	Y	This is test data and will be deleted
279	IDEHardDrive	ata	7	DROPDOWN	IDEHardDrive.ata	\N	\N	Y	Y	
280	System	ram	15	\N	\N	\N	\N	Y	Y	
281	System	videoRAM	16	\N	\N	\N	\N	Y	Y	
282	System	scsi	17	TOGGLE	\N	\N	\N	Y	Y	
283	System	sizeMb	18	\N	\N	\N	\N	Y	Y	
284	SystemBoard	pciSlots	3	\N	\N	\N	\N	Y	Y	
285	SystemBoard	vesaSlots	4	\N	\N	\N	\N	Y	Y	
286	SystemBoard	isaSlots	5	\N	\N	\N	\N	Y	Y	
287	SystemBoard	eisaSlots	6	\N	\N	\N	\N	Y	Y	
288	SystemBoard	agpSlot	7	TOGGLE	\N	\N	\N	Y	Y	
289	SystemBoard	ram30pin	8	\N	\N	\N	\N	Y	Y	
290	SystemBoard	ram72pin	9	\N	\N	\N	\N	Y	Y	
291	SystemBoard	ram168pin	10	\N	\N	\N	\N	Y	Y	
292	SystemBoard	dimmSpeed	11	DROPDOWN	SystemBoard.dimmSpeed	\N	\N	Y	Y	
293	SystemBoard	proc386	12	\N	\N	\N	\N	Y	Y	
294	SystemBoard	proc486	13	\N	\N	\N	\N	Y	Y	
295	SystemBoard	proc586	14	\N	\N	\N	\N	Y	Y	
296	SystemBoard	procMMX	15	\N	\N	\N	\N	Y	Y	
297	SystemBoard	procPRO	16	\N	\N	\N	\N	Y	Y	
298	SystemBoard	procSocket7	17	\N	\N	\N	\N	Y	Y	
299	SystemBoard	procSlot1	18	\N	\N	\N	\N	Y	Y	
300	System	chipClass	19	DROPDOWN	System.chipClass	\N	\N	Y	Y	
301	NetworkCard	rj45	5	TOGGLE	\N	\N	\N	Y	Y	
302	NetworkCard	aux	6	TOGGLE	\N	\N	\N	Y	Y	
303	NetworkCard	bnc	7	TOGGLE	\N	\N	\N	Y	Y	
304	NetworkCard	thicknet	8	TOGGLE	\N	\N	\N	Y	Y	
306	System	speed	20	\N	\N	\N	\N	Y	N	
309	Gizmo	cashValue	141	\N	\N	\N	\N	Y	Y	
312	NetworkingDevice	classTree	2	\N	\N	\N	\N	N	N	
313	NetworkingDevice	speed	3	DROPDOWN	NetworkCard.speed	\N	\N	Y	Y	
314	NetworkingDevice	rj45	5	TOGGLE	\N	\N	\N	Y	Y	
315	NetworkingDevice	aux	6	TOGGLE	\N	\N	\N	Y	Y	
316	NetworkingDevice	bnc	7	TOGGLE	\N	\N	\N	Y	Y	
317	NetworkingDevice	thicknet	8	TOGGLE	\N	\N	\N	Y	Y	
318	Gizmo	location	105	DROPDOWN	Gizmo.location	\N	\N	Y	N	
319	Laptop	id	1	\N	\N	\N	\N	N	N	
320	Laptop	classTree	2	\N	\N	\N	\N	N	N	
321	Laptop	ram	15	\N	\N	\N	\N	Y	Y	
322	Laptop	hardDriveSizeGb	18	\N	\N	\N	\N	Y	Y	
323	Laptop	chipClass	19	DROPDOWN	System.chipClass	\N	\N	Y	Y	
324	Laptop	chipSpeed	20	\N	\N	\N	\N	Y	N	
325	Gizmo	needsexpert	75	TOGGLE	\N	\N	\N	Y	N	Need expert attention?
6	Gizmo	obsolete	60	YNM	\N	\N	\N	Y	Y	Obsolete gizmo?
\.
--
-- TOC Entry ID 3 (OID 1484539)
--
-- Name: fieldmap_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"fieldmap_id_seq"', 325, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484487)
--
-- Name: holidays_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "holidays_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485120)
--
-- Name: holidays Type: TABLE Owner: fgdb
--

CREATE TABLE "holidays" (
	"id" integer DEFAULT nextval('Holidays_id_seq'::text) NOT NULL,
	"name" character varying(50),
	"holiday" date,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "holidays_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485120)
--
-- Name: holidays Type: TABLE DATA Owner: fgdb
--


COPY "holidays" FROM stdin;
1	Columbus Day	2003-10-11	2004-04-08 14:13:52-07	2003-10-06 11:17:39-07
2	Columbus Day	2004-10-09	2004-04-08 14:13:52-07	2003-10-06 11:18:14-07
3	Thanksgiving	2003-11-27	2004-04-08 14:13:52-07	2003-10-06 11:19:04-07
4	Thanksgiving	2003-11-28	2004-04-08 14:13:52-07	2003-10-06 11:19:09-07
5	Thanksgiving	2003-11-29	2004-04-08 14:13:52-07	2003-10-06 11:19:14-07
6	Thanksgiving	2004-11-25	2004-04-08 14:13:52-07	2003-10-06 11:19:33-07
7	Thanksgiving	2004-11-26	2004-04-08 14:13:52-07	2003-10-06 11:19:38-07
8	Thanksgiving	2004-11-27	2004-04-08 14:13:52-07	2003-10-06 11:19:42-07
9	Christmas	2003-12-25	2004-04-08 14:13:52-07	2003-10-06 11:20:31-07
10	Christmas	2004-12-25	2004-04-08 14:13:52-07	2003-10-06 11:20:36-07
11	New Years Day	2004-01-01	2004-04-08 14:13:52-07	2003-10-06 11:21:01-07
15	Independence Day	2004-07-03	2004-04-08 14:13:52-07	2003-10-06 11:23:31-07
14	May Day	2004-05-01	2004-04-08 14:13:52-07	2003-10-06 11:22:14-07
16	Martin Luther King Day	2004-01-17	2004-04-08 14:13:52-07	2003-10-06 11:24:34-07
17	Presidents Day	2004-02-14	2004-04-08 14:13:52-07	2003-10-06 11:25:02-07
18	Memorial Day	2004-05-29	2004-04-08 14:13:52-07	2003-10-06 11:25:33-07
19	Labor Day	2004-09-04	2004-04-08 14:13:52-07	2003-10-06 11:26:10-07
\.
--
-- TOC Entry ID 7 (OID 2417914)
--
-- Name: holidays_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "holidays_created_trigger" BEFORE INSERT ON "holidays"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 6 (OID 2417915)
--
-- Name: holidays_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "holidays_modified_trigger" BEFORE UPDATE ON "holidays"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 3 (OID 1484487)
--
-- Name: holidays_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"holidays_id_seq"', 19, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484493)
--
-- Name: links_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "links_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485147)
--
-- Name: links Type: TABLE Owner: fgdb
--

CREATE TABLE "links" (
	"id" integer DEFAULT nextval('Links_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"url" character varying(250),
	"helptext" character varying(100),
	"linktext" character varying(250),
	"broken" character varying(1) DEFAULT 'N',
	"howto" character varying(1) DEFAULT 'N',
	"external" character varying(1) DEFAULT 'N',
	CONSTRAINT "links_broken" CHECK (((broken = 'N'::"varchar") OR (broken = 'Y'::"varchar"))),
	CONSTRAINT "links_external" CHECK (((external = 'N'::"varchar") OR (external = 'Y'::"varchar"))),
	CONSTRAINT "links_howto" CHECK (((howto = 'N'::"varchar") OR (howto = 'Y'::"varchar"))),
	Constraint "links_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485147)
--
-- Name: links Type: TABLE DATA Owner: fgdb
--


COPY "links" FROM stdin;
1	2004-01-28 14:31:14-08				N	N	N
2	2004-01-28 15:16:29-08	reception/	Instructions for Receptionists	Front Desk Docs	N	Y	N
3	2004-04-09 12:20:23-07	donations/DonationProcessor.php	Donations	Donations	N	N	N
4	2004-04-09 12:22:14-07	sales/SaleProcessor.php	Sales	Sales	N	N	N
5	2004-01-28 15:17:09-08	deadtrees/	Forms	Forms	N	Y	N
6	2004-01-28 15:17:09-08	contact/ContactManager.php	Contacts	Contacts	N	N	N
7	2004-01-28 15:17:09-08	hours/	Volunteer Hours	Volunteer Hours	N	N	N
8	2004-01-28 15:17:09-08	syscheckout/syscheckout.php	Checkout&nbsp;Script	Checkout Script	N	N	N
9	2004-06-09 16:11:18-07	reports/members/incomeRptChoose.php	Daily&nbsp;Totals	Daily&nbsp;Totals	N	N	N
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
55	2004-01-28 15:40:21-08	reports/sales/salesRptChoose.php	Sales&nbsp;Reports	Sales&nbsp;Reports	N	N	N
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
\.
--
-- TOC Entry ID 3 (OID 1484493)
--
-- Name: links_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"links_id_seq"', 84, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484499)
--
-- Name: pagelinks_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "pagelinks_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485207)
--
-- Name: pagelinks Type: TABLE Owner: fgdb
--

CREATE TABLE "pagelinks" (
	"id" integer DEFAULT nextval('PageLinks_id_seq'::text) NOT NULL,
	"pageid" integer DEFAULT '0' NOT NULL,
	"linkid" integer DEFAULT '0' NOT NULL,
	"break" character varying(1) DEFAULT 'N',
	"displayorder" integer DEFAULT '0' NOT NULL,
	"helptext" character varying(100),
	"linktext" character varying(250),
	CONSTRAINT "pagelinks_break" CHECK (((break = 'N'::"varchar") OR (break = 'Y'::"varchar"))),
	Constraint "pagelinks_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485207)
--
-- Name: pagelinks Type: TABLE DATA Owner: fgdb
--


COPY "pagelinks" FROM stdin;
1	1	2	N	10		
2	1	1	Y	20		
3	1	3	N	30		
4	1	4	N	40		
5	1	1	Y	50		
6	1	5	N	60		
7	1	1	Y	70		
8	1	6	N	80		Volunteers
9	1	7	N	90		
10	1	1	Y	100		
11	1	8	N	110		
12	1	1	Y	120		
13	1	9	N	130		
14	1	10	N	140		
15	1	11	N	150		
16	1	12	N	160		
17	1	13	N	170		
18	1	14	N	180		
19	1	15	N	190		
20	1	1	Y	200		
21	1	16	N	210		
22	2	17	N	10		
23	2	18	N	20		
24	2	19	N	30		
25	2	20	N	40		
26	2	1	Y	45		
27	2	21	N	50		
28	2	22	N	60		
29	2	1	Y	65		
30	2	23	N	70		
31	2	1	Y	75		
32	2	24	N	80		
33	2	1	Y	85		
34	2	25	N	90		
35	2	1	Y	95		
36	2	16	N	100		
37	3	26	N	10		
38	3	1	Y	15		
39	3	5	N	20		
40	3	1	Y	25		
41	3	27	N	30		
42	3	1	Y	35		
43	3	16	N	40		
44	4	28	N	10		
45	4	1	Y	15		
46	4	29	N	20		
47	4	30	N	30		
48	4	1	Y	35		
49	4	31	N	40		
50	4	1	Y	45		
51	4	16	N	50		
52	5	32	N	10		
53	5	1	Y	15		
54	5	21	N	20		
55	5	22	N	30		
56	5	1	Y	35		
57	5	33	N	40		
58	5	34	N	50		
59	5	35	N	60		
60	5	1	Y	65		
61	5	36	N	70		
62	5	1	Y	75		
63	5	7	N	80		
64	5	1	Y	85		
65	5	37	N	90		
66	5	38	N	100		
67	5	1	Y	105		
68	5	16	N	110		
69	6	39	N	10		
70	6	1	Y	15		
71	6	40	N	20		
72	6	41	N	30		
73	6	1	Y	35		
74	6	42	N	40		
75	6	1	Y	45		
76	6	21	N	50		
77	6	22	N	60		
78	6	1	Y	65		
79	6	43	N	70		
80	6	1	Y	75		
81	6	16	N	80		
82	7	44	N	10		
83	7	45	N	20		
84	7	46	N	30		
85	7	1	Y	35		
86	7	21	N	40		
87	7	22	N	50		
88	7	1	Y	55		
89	7	8	N	60		
90	7	1	Y	65		
91	7	47	N	70		
92	7	1	Y	75		
93	7	24	N	80		
94	7	1	Y	85		
95	7	48	N	90		
96	7	1	Y	95		
97	7	16	N	100		
98	8	49	N	10		
99	8	50	N	20		
100	8	1	Y	25		
101	8	51	N	30		
102	8	47	N	40		
103	8	1	Y	45		
104	8	69	N	50		
105	8	70	N	60		
106	8	1	Y	65		
107	8	7	N	70		
108	8	1	Y	75		
109	8	21	N	80		
110	8	22	N	90		
111	8	1	Y	95		
112	8	71	N	100		
113	8	1	Y	105		
114	8	16	N	110		
115	9	52	N	10		
116	9	1	Y	15		
117	9	53	N	20		
118	9	1	Y	25		
119	9	54	N	30		
120	9	1	Y	35		
121	9	21	N	40		
122	9	22	N	50		
123	9	1	Y	55		
124	9	9	N	60		
125	9	55	N	70		
126	9	56	N	80		
127	9	1	Y	85		
128	9	16	N	90		
129	10	45	N	10		
130	10	57	N	20		
131	10	1	Y	25		
132	10	58	N	30		
133	10	1	Y	35		
134	10	21	N	40		
135	10	22	N	50		
136	10	1	Y	55		
137	10	24	N	60		
138	10	1	Y	65		
139	10	59	N	70		
140	10	60	N	80		
141	10	1	Y	85		
142	10	16	N	90		
143	11	6	N	10		Find&nbsp;Contact
144	11	1	Y	15		
145	11	61	N	20		
146	11	1	Y	25		
147	11	62	N	30		
148	11	1	Y	35		
149	11	5	N	40		
150	11	1	Y	45		
151	11	63	N	50		
152	11	1	Y	55		
153	11	64	N	60		
154	11	65	N	70		
155	11	7	N	80		
156	11	66	N	90		
157	11	67	N	100		
158	11	9	N	110		
159	11	68	N	120		
160	11	1	Y	125		
161	11	16	N	130		
162	11	83	N	65		
163	11	84	N	66		
164	1	1	Y	35		
\.
--
-- TOC Entry ID 3 (OID 1484499)
--
-- Name: pagelinks_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"pagelinks_id_seq"', 164, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484501)
--
-- Name: pages_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "pages_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485210)
--
-- Name: pages Type: TABLE Owner: fgdb
--

CREATE TABLE "pages" (
	"id" integer DEFAULT nextval('Pages_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"shortname" character varying(25),
	"longname" character varying(100),
	"visible" character varying(1) DEFAULT 'Y',
	"linkid" integer DEFAULT '0' NOT NULL,
	"displayorder" integer DEFAULT '0' NOT NULL,
	"helptext" character varying(100),
	CONSTRAINT "pages_visible" CHECK (((visible = 'N'::"varchar") OR (visible = 'Y'::"varchar"))),
	Constraint "pages_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485210)
--
-- Name: pages Type: TABLE DATA Owner: fgdb
--


COPY "pages" FROM stdin;
1	2004-02-05 10:56:47-08	2004-01-23 15:28:22-08	FRONTDESK	Reception&nbsp;Area	Y	72	10	
2	2004-02-05 10:56:47-08	2004-01-23 15:28:49-08	RECEIVING	Donation&nbsp;Receiving&nbsp;Area	Y	73	20	
3	2004-02-05 10:56:47-08	2004-01-23 15:29:14-08	TESTING	Gizmo Testing&nbsp;Area	N	74	30	
4	2004-02-05 10:56:47-08	2004-01-23 15:28:13-08	EVALUATION	System&nbsp;Evaluation&nbsp;Area	N	75	40	
5	2004-02-05 10:56:47-08	2004-01-23 15:28:05-08	BUILD	Build Area	Y	76	50	
6	2004-02-05 10:56:47-08	2004-01-23 15:28:42-08	PRINTERS	Printer Repair&nbsp;Area	Y	77	60	
7	2004-02-05 10:56:47-08	2004-01-23 15:28:28-08	LAB	Lab (the old&nbsp;Classroom)	Y	78	70	
8	2004-02-05 10:56:47-08	2004-01-23 15:29:07-08	SUPPORT	Technical&nbsp;Support&nbsp;Area	Y	79	80	
9	2004-02-05 10:56:47-08	2004-01-23 15:29:01-08	STORE	Thrift Store	Y	80	90	
10	2004-02-05 10:56:47-08	2004-01-23 15:28:54-08	RECYCLING	Recycling&nbsp;Area	N	81	100	
11	2004-02-05 10:56:47-08	2004-01-23 15:28:34-08	OFFICE	Administrative&nbsp;Offices	Y	82	110	
\.
--
-- TOC Entry ID 7 (OID 2417932)
--
-- Name: pages_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pages_created_trigger" BEFORE INSERT ON "pages"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 6 (OID 2417933)
--
-- Name: pages_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pages_modified_trigger" BEFORE UPDATE ON "pages"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 3 (OID 1484501)
--
-- Name: pages_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"pages_id_seq"', 11, true);

--
-- Selected TOC Entries:
--

--
-- TOC Entry ID 2 (OID 1484547)
--
-- Name: relations_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "relations_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 1485348)
--
-- Name: relations Type: TABLE Owner: fgdb
--

CREATE TABLE "relations" (
	"id" integer DEFAULT nextval('relations_id_seq'::text) NOT NULL,
	"parenttable" character varying(50),
	"parentfield" character varying(50),
	"parentmultiplicity" character varying(10),
	"childtable" character varying(50),
	"childfield" character varying(50),
	"childmultiplicity" character varying(10),
	Constraint "relations_pkey" Primary Key ("id")
);

--
-- Data for TOC Entry ID 5 (OID 1485348)
--
-- Name: relations Type: TABLE DATA Owner: fgdb
--


COPY "relations" FROM stdin;
1	System	id	0:1	Component	inSysId	0:M
3	Contact	id	1:1	Volunteer	id	0:1
4	Contact	id	1:1	Donor	id	0:1
5	Contact	id	1:1	Recipient	id	0:1
\.
--
-- TOC Entry ID 3 (OID 1484547)
--
-- Name: relations_id_seq Type: SEQUENCE SET Owner: fgdb
--

SELECT setval ('"relations_id_seq"', 5, true);


