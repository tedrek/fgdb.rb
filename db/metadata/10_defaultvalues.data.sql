--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'fgdb';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 515302)
-- Name: defaultvalues; Type: TABLE DATA; Schema: public; Owner: fgdb
--

COPY defaultvalues (id, classtree, fieldname, defaultvalue) FROM stdin;
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


