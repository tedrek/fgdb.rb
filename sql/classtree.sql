# MySQL dump 8.13
#
# Host: localhost    Database: freegeek
#--------------------------------------------------------
# Server version	3.23.36

#
# Table structure for table 'classTree'
#

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

#
# Dumping data for table 'classTree'
#

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

