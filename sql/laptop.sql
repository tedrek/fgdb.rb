-- MySQL dump 8.21
--
-- Host: localhost    Database: fgdb
---------------------------------------------------------
-- Server version	3.23.49-log

--
-- Table structure for table 'Laptop'
--

DROP TABLE IF EXISTS Laptop;
CREATE TABLE Laptop (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  ram int(7) default NULL,
  hardDriveSizeGb double(8,2) default NULL,
  chipClass varchar(15) NOT NULL default '',
  chipSpeed int(6) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

--
-- Dumping data for table 'Laptop'
--


INSERT INTO Laptop (id, classTree, ram, hardDriveSizeGb, chipClass, chipSpeed) VALUES (150160,'Gizmo.Laptop',0,0.00,'',0);

--
-- Table structure for table 'fieldMap'
--

DROP TABLE IF EXISTS fieldMap;
CREATE TABLE fieldMap (
  id int(11) NOT NULL auto_increment,
  tableName varchar(50) NOT NULL default '',
  fieldName varchar(50) NOT NULL default '',
  displayOrder int(11) NOT NULL default '0',
  inputWidget varchar(50) default NULL,
  inputWidgetParameters varchar(100) default NULL,
  outputWidget varchar(50) default NULL,
  outputWidgetParameters varchar(100) default NULL,
  editable enum('N','Y') default 'Y',
  helpLink enum('N','Y') default 'N',
  description varchar(100) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY tableName (tableName),
  KEY fieldName (fieldName),
  KEY displayOrder (displayOrder)
) TYPE=MyISAM;

--
-- Dumping data for table 'fieldMap'
--


INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (1,'Gizmo','id',10,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (2,'Gizmo','classTree',20,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (4,'Gizmo','oldStatus',40,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (5,'Gizmo','newStatus',50,'STATUSCHANGE','Gizmo.newStatus',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (6,'Gizmo','obsolete',60,'YNM',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (7,'Gizmo','working',70,'YNM',NULL,NULL,NULL,'Y','Y','Is Unit Working?');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (305,'Gizmo','value',140,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (11,'Gizmo','architecture',80,'DROPDOWN','Gizmo.architecture',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (12,'Gizmo','manufacturer',90,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (13,'Gizmo','modelNumber',100,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (14,'Gizmo','notes',110,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (15,'Gizmo','created',25,NULL,NULL,'DATETIME',NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (16,'Gizmo','modified',24,NULL,NULL,'DATETIME',NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (17,'Component','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (18,'Component','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (19,'Component','inSysId',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (310,'Gizmo','gizmoType',21,NULL,NULL,NULL,NULL,'N','N','Type');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (22,'Card','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (23,'Card','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (30,'Card','slotType',4,'DROPDOWN','Card.slotType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (35,'MiscCard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (36,'MiscCard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (37,'MiscCard','miscNotes',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (38,'ModemCard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (39,'ModemCard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (40,'ModemCard','speed',3,'DROPDOWN','ModemCard.speed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (46,'NetworkCard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (47,'NetworkCard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (48,'NetworkCard','speed',3,'DROPDOWN','NetworkCard.speed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (54,'SCSICard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (55,'SCSICard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (56,'SCSICard','internalInterface',3,'DROPDOWN','SCSICard.internalInterface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (60,'SCSICard','externalInterface',4,'DROPDOWN','SCSICard.externalInterface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (63,'SCSICard','parms',5,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (64,'SoundCard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (65,'SoundCard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (66,'SoundCard','soundType',3,'DROPDOWN','SoundCard.soundType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (68,'VideoCard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (69,'VideoCard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (70,'VideoCard','videoMemory',3,'DROPDOWN','VideoCard.videoMemory',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (75,'VideoCard','resolutions',4,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (76,'ControllerCard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (77,'ControllerCard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (78,'ControllerCard','numSerial',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (79,'ControllerCard','numParallel',4,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (80,'ControllerCard','numIDE',5,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (81,'ControllerCard','floppy',6,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (82,'SystemCase','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (83,'SystemCase','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (84,'SystemCase','caseType',3,'DROPDOWN','SystemCase.caseType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (90,'Coprocessor','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (91,'Coprocessor','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (92,'Coprocessor','chipType',3,'DROPDOWN','Coprocessor.chipType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (93,'Coprocessor','chipType',3,'DROPDOWN','Coprocessor.chipType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (94,'Drive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (95,'Drive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (96,'CDDrive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (97,'CDDrive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (98,'CDDrive','interface',3,'DROPDOWN','CDDrive.interface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (100,'CDDrive','speed',4,'DROPDOWN','CDDrive.speed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (103,'CDDrive','writeMode',5,'DROPDOWN','CDDrive.writeMode',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (308,'Gizmo','linuxfund',150,'YNM',NULL,NULL,NULL,'Y','N','Publish to LinuxFund.org?');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (307,'CDDrive','scsi',6,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (118,'FloppyDrive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (119,'FloppyDrive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (120,'FloppyDrive','diskSize',3,'DROPDOWN','FloppyDrive.diskSize',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (122,'FloppyDrive','capacity',4,'DROPDOWN','FloppyDrive.capacity',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (127,'FloppyDrive','cylinders',5,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (128,'FloppyDrive','heads',6,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (129,'FloppyDrive','sectors',7,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (130,'IDEHardDrive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (131,'IDEHardDrive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (132,'IDEHardDrive','cylinders',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (133,'IDEHardDrive','heads',4,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (134,'IDEHardDrive','sectors',5,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (135,'IDEHardDrive','sizeMb',6,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (136,'MiscDrive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (137,'MiscDrive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (138,'MiscDrive','miscNotes',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (139,'SCSIHardDrive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (140,'SCSIHardDrive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (141,'SCSIHardDrive','sizeMb',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (142,'SCSIHardDrive','scsiVersion',4,'DROPDOWN','SCSIHardDrive.scsiVersion',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (149,'TapeDrive','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (150,'TapeDrive','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (151,'TapeDrive','interface',3,'DROPDOWN','TapeDrive.interface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (154,'Keyboard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (155,'Keyboard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (156,'Keyboard','kbType',3,'DROPDOWN','Keyboard.kbType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (160,'Keyboard','numKeys',4,'DROPDOWN','Keyboard.numKeys',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (164,'MiscComponent','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (165,'MiscComponent','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (166,'MiscComponent','miscNotes',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (167,'Modem','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (168,'Modem','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (169,'Modem','speed',3,'DROPDOWN','Modem.speed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (175,'Monitor','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (176,'Monitor','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (177,'Monitor','size',3,'DROPDOWN','Monitor.size',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (184,'Monitor','resolution',4,'DROPDOWN','Monitor.resolution',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (188,'PointingDevice','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (189,'PointingDevice','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (190,'PointingDevice','connector',3,'DROPDOWN','PointingDevice.connector',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (193,'PointingDevice','pointerType',4,'DROPDOWN','PointingDevice.pointerType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (198,'PowerSupply','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (199,'PowerSupply','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (200,'PowerSupply','watts',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (201,'PowerSupply','connection',4,'DROPDOWN','PowerSupply.connection',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (203,'Printer','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (204,'Printer','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (205,'Printer','speedppm',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (206,'Printer','printerType',4,'DROPDOWN','Printer.printerType',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (209,'Printer','interface',5,'DROPDOWN','Printer.interface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (211,'Processor','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (212,'Processor','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (213,'Processor','chipClass',3,'DROPDOWN','Processor.chipClass',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (222,'Processor','interface',4,'DROPDOWN','Processor.interface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (224,'Processor','speed',5,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (225,'RAM','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (226,'RAM','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (227,'RAM','pins',3,'DROPDOWN','RAM.pins',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (230,'RAM','size',4,'DROPDOWN','RAM.size',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (239,'RAM','speed',5,'DROPDOWN','RAM.speed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (246,'Scanner','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (247,'Scanner','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (248,'Scanner','interface',3,'DROPDOWN','Scanner.interface',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (250,'Speaker','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (251,'Speaker','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (252,'Speaker','powered',3,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (253,'Speaker','subwoofer',4,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (254,'SystemBoard','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (255,'SystemBoard','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (311,'NetworkingDevice','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (258,'MiscGizmo','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (259,'MiscGizmo','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (260,'System','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (261,'System','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (262,'System','systemConfiguration',30,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (263,'System','systemBoard',40,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (264,'System','adapterInformation',50,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (265,'System','multiprocessorInformation',60,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (266,'System','displayDetails',70,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (267,'System','displayInformation',80,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (268,'System','scsiInformation',90,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (269,'System','pcmciaInformation',100,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (270,'System','modemInformation',110,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (271,'System','multimediaInformation',120,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (272,'System','plugNplayInformation',130,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (273,'System','physicalDrives',140,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (278,'Gizmo','testData',120,'TOGGLE',NULL,NULL,NULL,'Y','Y','This is test data and will be deleted');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (279,'IDEHardDrive','ata',7,'DROPDOWN','IDEHardDrive.ata',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (280,'System','ram',15,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (281,'System','videoRAM',16,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (282,'System','scsi',17,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (283,'System','sizeMb',18,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (284,'SystemBoard','pciSlots',3,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (285,'SystemBoard','vesaSlots',4,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (286,'SystemBoard','isaSlots',5,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (287,'SystemBoard','eisaSlots',6,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (288,'SystemBoard','agpSlot',7,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (289,'SystemBoard','ram30pin',8,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (290,'SystemBoard','ram72pin',9,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (291,'SystemBoard','ram168pin',10,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (292,'SystemBoard','dimmSpeed',11,'DROPDOWN','SystemBoard.dimmSpeed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (293,'SystemBoard','proc386',12,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (294,'SystemBoard','proc486',13,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (295,'SystemBoard','proc586',14,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (296,'SystemBoard','procMMX',15,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (297,'SystemBoard','procPRO',16,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (298,'SystemBoard','procSocket7',17,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (299,'SystemBoard','procSlot1',18,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (300,'System','chipClass',19,'DROPDOWN','System.chipClass',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (301,'NetworkCard','rj45',5,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (302,'NetworkCard','aux',6,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (303,'NetworkCard','bnc',7,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (304,'NetworkCard','thicknet',8,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (306,'System','speed',20,NULL,NULL,NULL,NULL,'Y','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (309,'Gizmo','cashValue',141,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (312,'NetworkingDevice','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (313,'NetworkingDevice','speed',3,'DROPDOWN','NetworkCard.speed',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (314,'NetworkingDevice','rj45',5,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (315,'NetworkingDevice','aux',6,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (316,'NetworkingDevice','bnc',7,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (317,'NetworkingDevice','thicknet',8,'TOGGLE',NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (318,'Gizmo','location',105,'DROPDOWN','Gizmo.location',NULL,NULL,'Y','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (319,'Laptop','id',1,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (320,'Laptop','classTree',2,NULL,NULL,NULL,NULL,'N','N','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (321,'Laptop','ram',15,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (322,'Laptop','hardDriveSizeGb',18,NULL,NULL,NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (323,'Laptop','chipClass',19,'DROPDOWN','System.chipClass',NULL,NULL,'Y','Y','');
INSERT INTO fieldMap (id, tableName, fieldName, displayOrder, inputWidget, inputWidgetParameters, outputWidget, outputWidgetParameters, editable, helpLink, description) VALUES (324,'Laptop','chipSpeed',20,NULL,NULL,NULL,NULL,'Y','N','');

--
-- Table structure for table 'classTree'
--

DROP TABLE IF EXISTS classTree;
CREATE TABLE classTree (
  id int(11) NOT NULL auto_increment,
  classTree varchar(100) NOT NULL default '',
  tableName varchar(50) NOT NULL default '',
  level int(11) default NULL,
  instantiable enum('N','Y') NOT NULL default 'Y',
  intakeCode varchar(10) default NULL,
  intakeAdd int(4) default NULL,
  description varchar(50) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree),
  KEY tableName (tableName)
) TYPE=MyISAM;

--
-- Dumping data for table 'classTree'
--


INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (1,'Gizmo','Gizmo',1,'N',NULL,0,'Gizmo');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (2,'Gizmo.Component','Component',2,'N',NULL,0,'Component');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (4,'Gizmo.Component.Card.MiscCard','MiscCard',4,'Y','MISCCARD',0,'Miscellaneous Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (5,'Gizmo.Component.Card.ModemCard','ModemCard',4,'Y','MODEMCARD',0,'Regular Internal Modem');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (6,'Gizmo.Component.Card.NetworkCard','NetworkCard',4,'Y','NETWORKCAR',0,'Network Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (7,'Gizmo.Component.Card.SCSICard','SCSICard',4,'Y','SCSICARD',0,'SCSI Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (8,'Gizmo.Component.Card.SoundCard','SoundCard',4,'Y','SOUNDCARD',0,'Sound Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (9,'Gizmo.Component.Card.VideoCard','VideoCard',4,'Y','VIDEOCARD',0,'Video Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (10,'Gizmo.Component.Card.ControllerCard','ControllerCard',4,'Y','CONTROLLER',0,'I/O or Controller Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (11,'Gizmo.Component.SystemCase','SystemCase',4,'Y','SYSTEMCASE',0,'System Case');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (13,'Gizmo.Component.Drive','Drive',3,'N',NULL,0,'Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (14,'Gizmo.Component.Drive.CDDrive','CDDrive',4,'Y','CDDRIVE',0,'CD Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (16,'Gizmo.Component.Drive.FloppyDrive','FloppyDrive',4,'Y','FLOPPYDRIV',0,'Floppy Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (17,'Gizmo.Component.Drive.IDEHardDrive','IDEHardDrive',4,'Y','IDEHARDDRI',0,'Regular IDE Hard Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (18,'Gizmo.Component.Drive.MiscDrive','MiscDrive',4,'Y','MISCDRIVE',0,'Miscellaneous Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (19,'Gizmo.Component.Drive.SCSIHardDrive','SCSIHardDrive',4,'Y','SCSIHARDDR',0,'SCSI Hard Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (20,'Gizmo.Component.Drive.TapeDrive','TapeDrive',4,'Y','TAPEDRIVE',0,'Tape Drive');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (21,'Gizmo.Component.Keyboard','Keyboard',3,'Y','KEYBOARD',0,'Keyboard');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (22,'Gizmo.Component.MiscComponent','MiscComponent',3,'Y','MISCCOMPON',0,'Miscellaneous Component');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (23,'Gizmo.Component.Modem','Modem',3,'Y','MODEM',0,'External Modem');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (24,'Gizmo.Component.Monitor','Monitor',3,'Y','MONITOR',0,'Monitor');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (25,'Gizmo.Component.PointingDevice','PointingDevice',3,'Y','POINTINGDE',0,'Mouse or other Pointing Device');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (26,'Gizmo.Component.PowerSupply','PowerSupply',3,'Y','POWERSUPPL',0,'Power Supply');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (27,'Gizmo.Component.Printer','Printer',3,'Y','PRINTER',0,'Printer');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (28,'Gizmo.Component.Processor','Processor',3,'Y','PROCESSOR',0,'Processor');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (30,'Gizmo.Component.Scanner','Scanner',3,'Y','SCANNER',0,'Scanner');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (31,'Gizmo.Component.Speaker','Speaker',3,'Y','SPEAKER',0,'Speaker');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (32,'Gizmo.Component.SystemBoard','SystemBoard',3,'Y','SYSTEMBOAR',0,'Motherboard (System Mainboard)');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (36,'Gizmo.NetworkingDevice','NetworkingDevice',2,'Y','NETWORKING',0,'Networking Device');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (34,'Gizmo.MiscGizmo','MiscGizmo',2,'Y','MISCGIZMO',0,'Miscellaneous Gizmo');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (35,'Gizmo.System','System',2,'Y',NULL,0,'System');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (3,'Gizmo.Component.Card','Card',3,'N',NULL,0,'Card');
INSERT INTO classTree (id, classTree, tableName, level, instantiable, intakeCode, intakeAdd, description) VALUES (37,'Gizmo.Laptop','Laptop',2,'Y',NULL,0,'System');

--
-- Table structure for table 'defaultValues'
--

DROP TABLE IF EXISTS defaultValues;
CREATE TABLE defaultValues (
  id int(11) NOT NULL auto_increment,
  classTree varchar(100) NOT NULL default '',
  fieldName varchar(50) NOT NULL default '',
  defaultValue varchar(50) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree),
  KEY fieldName (fieldName)
) TYPE=MyISAM;

--
-- Dumping data for table 'defaultValues'
--


INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (1,'Gizmo.Component.Card.MiscCard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (2,'Gizmo.Component.Card.ModemCard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (3,'Gizmo.Component.Card.NetworkCard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (4,'Gizmo.Component.Card.SCSICard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (5,'Gizmo.Component.Card.SoundCard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (6,'Gizmo.Component.Card.VideoCard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (7,'Gizmo.Component.Card.ControllerCard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (8,'Gizmo.Component.SystemCase','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (10,'Gizmo.Component.Drive.CDDrive','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (12,'Gizmo.Component.Drive.FloppyDrive','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (13,'Gizmo.Component.Drive.IDEHardDrive','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (14,'Gizmo.Component.Drive.MiscDrive','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (15,'Gizmo.Component.Drive.SCSIHardDrive','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (16,'Gizmo.Component.Drive.TapeDrive','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (17,'Gizmo.Component.Keyboard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (18,'Gizmo.Component.MiscComponent','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (19,'Gizmo.Component.Modem','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (20,'Gizmo.Component.Monitor','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (21,'Gizmo.Component.PointingDevice','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (22,'Gizmo.Component.PowerSupply','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (23,'Gizmo.Component.Printer','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (24,'Gizmo.Component.Processor','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (26,'Gizmo.Component.Scanner','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (27,'Gizmo.Component.Speaker','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (28,'Gizmo.Component.SystemBoard','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (39,'Gizmo.NetworkingDevice','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (34,'Gizmo.System','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (33,'Gizmo.MiscGizmo','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (36,'Gizmo.System','gizmoType','System');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (37,'Gizmo.Component.Monitor','gizmoType','Monitor');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (38,'Gizmo.Component.Printer','gizmoType','Printer');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (40,'Gizmo.Laptop','newStatus','Received');
INSERT INTO defaultValues (id, classTree, fieldName, defaultValue) VALUES (41,'Gizmo.Laptop','gizmoType','System');

