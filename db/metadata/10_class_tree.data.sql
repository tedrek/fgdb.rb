--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

-- SET SESSION AUTHORIZATION 'fgdb';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 515288)
-- Name: classtree; Type: TABLE DATA; Schema: public; Owner: fgdb
--

COPY class_trees (id, class_tree, table_name, "level", instantiable, intake_code, intake_add, description) FROM stdin;
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


