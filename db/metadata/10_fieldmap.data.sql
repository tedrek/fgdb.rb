--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'fgdb';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 515305)
-- Name: fieldmap; Type: TABLE DATA; Schema: public; Owner: fgdb
--

COPY fieldmap (id, tablename, fieldname, displayorder, inputwidget, inputwidgetparameters, outputwidget, outputwidgetparameters, editable, helplink, description) FROM stdin;
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


