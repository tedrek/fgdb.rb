-- MySQL dump 8.13
--
-- Host: localhost    Database: freegeek
----------------------------------------------------------
-- Server version	3.23.36

--
-- Table structure for table 'DaysOff'
--

DROP TABLE IF EXISTS DaysOff;
CREATE TABLE DaysOff (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  dayOff date default NULL,
  vacation enum('N','Y') default 'N',
  offsiteWork enum('N','Y') default 'N',
  notes text NOT NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'DaysOff'
--


--
-- Table structure for table 'Holidays'
--

DROP TABLE IF EXISTS Holidays;
CREATE TABLE Holidays (
  id int(11) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  holiday date default NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'Holidays'
--

INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (1,'Columbus Day','2003-10-11',20031006111739,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (2,'Columbus Day','2004-10-09',20031006111814,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (3,'Thanksgiving','2003-11-27',20031006111904,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (4,'Thanksgiving','2003-11-28',20031006111909,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (5,'Thanksgiving','2003-11-29',20031006111914,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (6,'Thanksgiving','2004-11-25',20031006111933,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (7,'Thanksgiving','2004-11-26',20031006111938,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (8,'Thanksgiving','2004-11-27',20031006111942,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (9,'Christmas','2003-12-25',20031006112031,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (10,'Christmas','2004-12-25',20031006112036,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (11,'New Years Day','2004-01-01',20031006112101,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (15,'Independence Day','2004-07-03',20031006112331,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (14,'May Day','2004-05-01',20031006112214,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (16,'Martin Luther King Day','2004-01-17',20031006112434,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (17,'Presidents Day','2004-02-14',20031006112502,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (18,'Memorial Day','2004-05-29',20031006112533,00000000000000);
INSERT INTO Holidays (id, name, holiday, modified, created) VALUES (19,'Labor Day','2004-09-04',20031006112610,00000000000000);

--
-- Table structure for table 'Jobs'
--

DROP TABLE IF EXISTS Jobs;
CREATE TABLE Jobs (
  id int(11) NOT NULL auto_increment,
  job varchar(50) NOT NULL default '',
  scheduleName varchar(15) NOT NULL default 'Main',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'Jobs'
--

INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (1,'Build','Main',20040324080454,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (2,'BBBees','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (3,'Recycling','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (4,'Reception','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (5,'PB/BBBB','Main',20040324080609,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (6,'Adoption','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (7,'Tour','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (8,'Admin','Main',20040331083842,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (10,'Staff','Main',20040330100501,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (11,'Open','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (12,'Close','Main',20040324080346,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (13,'Book','Main',20040326195351,20040324080346);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (14,'Coders','Main',20040324080430,20040324080430);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (16,'Store','Main',20040324080636,20040324080636);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (17,'Support','Main',20040324080636,20040324080636);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (18,'BoardPrep','Main',20040402124409,20040402124409);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (19,'ReceptLite','Main',20040402124422,20040402124422);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (20,'StoreTest','Main',20040402124451,20040402124451);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (21,'Vol Intake','Main',20040402132609,20040402132609);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (22,'AdoptClass','Main',20040403154341,20040403154341);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (23,'CommandLine','Main',20040403154352,20040403154352);
INSERT INTO Jobs (id, job, scheduleName, modified, created) VALUES (24,'BuildWorksh','Main',20040403154402,20040403154402);

--
-- Table structure for table 'WeeklyShifts'
--

DROP TABLE IF EXISTS WeeklyShifts;
CREATE TABLE WeeklyShifts (
  id int(11) NOT NULL auto_increment,
  scheduleName varchar(15) NOT NULL default 'Main',
  contactId int(11) NOT NULL default '0',
  jobId int(11) NOT NULL default '0',
  weekday int(11) NOT NULL default '0',
  inTime time default NULL,
  outTime time default NULL,
  meeting enum('N','Y') default 'N',
  effective date NOT NULL default '2004-01-01',
  ineffective date NOT NULL default '3004-01-01',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'WeeklyShifts'
--

INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (1,'Main',157,1,2,'11:00:00','15:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (2,'Main',157,1,3,'15:00:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (3,'Main',5144,5,2,'11:00:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (4,'Main',6144,5,2,'15:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (7,'Main',4190,11,2,'10:30:00','11:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (8,'Main',5144,12,2,'19:15:00','19:45:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (9,'Main',1795,16,2,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (11,'Main',4019,16,2,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (12,'Main',4253,4,2,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (13,'Main',6536,4,2,'14:15:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (16,'Main',5144,1,3,'11:00:00','15:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (17,'Main',1,14,2,'18:30:00','21:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (18,'Main',157,5,3,'11:00:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (19,'Main',125,5,3,'15:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (22,'Main',6002,11,3,'10:00:00','10:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (23,'Main',4190,12,3,'19:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (24,'Main',125,6,4,'12:00:00','16:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (25,'Main',1795,16,3,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (27,'Main',1795,16,3,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (28,'Main',4253,4,3,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (29,'Main',6536,4,3,'14:15:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (32,'Main',157,1,4,'11:00:00','15:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (33,'Main',1,5,4,'11:00:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (34,'Main',1,5,4,'15:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (37,'Main',5144,11,5,'09:30:00','10:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (38,'Main',6190,12,4,'19:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (39,'Main',1795,16,4,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (41,'Main',1795,16,4,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (42,'Main',4253,4,4,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (43,'Main',6536,4,4,'14:15:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (46,'Main',5144,1,5,'11:00:00','15:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (48,'Main',748,8,5,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (49,'Main',157,5,5,'11:00:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (50,'Main',390,5,5,'15:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (131,'Main',4572,4,5,'16:45:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,20040327085010);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (53,'Main',157,11,4,'10:30:00','11:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (54,'Main',390,12,5,'19:00:00','19:30:00','N','2004-01-01','3004-12-31',20040406110541,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (55,'Main',125,6,6,'12:00:00','16:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (56,'Main',4019,16,5,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (57,'Main',1,16,5,'14:30:00','15:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (58,'Main',4019,16,5,'15:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (59,'Main',4253,4,5,'11:00:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (60,'Main',125,4,5,'14:00:00','16:45:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (63,'Main',5144,1,6,'10:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (64,'Main',5144,1,5,'16:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (65,'Main',1,14,4,'18:30:00','21:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (66,'Main',6144,5,6,'11:00:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (67,'Main',5144,5,6,'15:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (130,'Main',5144,2,6,'17:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040327074938);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (129,'Main',6190,2,4,'12:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040327074936);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (70,'Main',6144,11,6,'10:30:00','11:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (71,'Main',5144,12,6,'19:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (72,'Main',4019,16,6,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (73,'Main',4572,16,6,'14:30:00','15:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (74,'Main',4019,16,6,'15:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (75,'Main',4253,4,6,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (76,'Main',6536,4,6,'14:15:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (79,'Main',693,17,2,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (80,'Main',693,17,5,'12:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (81,'Main',5144,1,2,'15:00:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (82,'Main',4190,2,2,'11:00:00','16:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (117,'Main',6002,8,4,'10:00:00','11:00:00','N','2004-01-01','3004-12-31',20040406110203,20040326194508);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (84,'Main',6112,2,2,'16:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (85,'Main',6112,2,3,'11:00:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (116,'Main',6002,8,3,'10:30:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040326194506);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (87,'Main',4190,2,3,'14:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (88,'Main',6002,2,4,'11:00:00','12:30:00','N','2004-01-01','3004-12-31',20040406110014,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (115,'Main',4190,8,2,'16:30:00','17:00:00','N','2004-01-01','3004-12-31',20040403144656,20040326194504);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (90,'Main',6112,2,4,'14:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (91,'Main',4190,2,5,'11:00:00','17:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (114,'Main',6002,8,1,'10:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040326194501);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (93,'Main',390,2,5,'17:00:00','19:00:00','N','2004-01-01','3004-12-31',20040406110415,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (94,'Main',6190,2,6,'11:00:00','12:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (113,'Main',748,8,3,'11:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403144656,20040326194043);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (96,'Main',6112,2,6,'12:30:00','17:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (97,'Main',6190,3,2,'10:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (98,'Main',5966,3,2,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (99,'Main',6190,3,2,'15:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (100,'Main',5966,3,3,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (102,'Main',6112,3,3,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (103,'Main',5966,3,4,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (105,'Main',6190,3,4,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (106,'Main',6190,3,5,'11:00:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (107,'Main',5966,3,5,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (108,'Main',6190,3,5,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (109,'Main',5966,3,6,'11:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (111,'Main',6190,3,6,'15:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040324171007);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (112,'Main',6085,1,6,'15:00:00','19:15:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (118,'Main',6002,8,5,'11:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040326194510);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (119,'Main',6002,8,5,'14:30:00','17:30:00','N','2004-01-01','3004-12-31',20040406114625,20040326194744);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (120,'Main',6002,8,4,'13:30:00','17:30:00','N','2004-01-01','3004-12-31',20040406114625,20040326194746);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (121,'Main',6002,8,3,'14:30:00','17:30:00','N','2004-01-01','3004-12-31',20040403144656,20040326194748);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (122,'Main',6002,8,2,'14:30:00','17:30:00','N','2004-01-01','3004-12-31',20040406114804,20040326194749);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (123,'Main',6002,8,1,'14:30:00','17:30:00','N','2004-01-01','3004-12-31',20040406114625,20040326194751);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (125,'Main',6085,13,2,'10:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040326195602);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (126,'Main',6085,13,3,'10:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040326195603);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (127,'Main',6085,13,4,'10:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040326195605);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (128,'Main',6085,13,5,'10:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040326195608);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (145,'Main',4190,8,5,'17:00:00','17:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331084824);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (139,'Main',6144,8,3,'15:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212800);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (138,'Main',6144,8,2,'16:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212756);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (137,'Main',6144,8,6,'12:00:00','12:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212738);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (133,'Main',0,10,5,'10:00:00','11:00:00','Y','2004-01-01','3004-12-31',20040403144656,20040330100635);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (136,'Main',6144,8,5,'11:00:00','12:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212735);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (135,'Main',6144,8,3,'10:30:00','12:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212731);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (134,'Main',6144,8,2,'10:30:00','12:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212725);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (140,'Main',6144,8,5,'15:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040330212806);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (141,'Main',6144,8,6,'15:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040330212809);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (143,'Main',6190,3,4,'10:30:00','12:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331081452);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (144,'Main',6190,3,6,'12:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331081457);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (146,'Main',6002,8,2,'10:30:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331084859);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (147,'Main',4190,8,3,'13:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331084917);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (186,'Main',6190,3,6,'10:30:00','11:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331173722);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (149,'Main',693,17,0,'12:00:00','13:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331091424);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (150,'Main',693,17,4,'12:00:00','13:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331091440);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (151,'Main',390,8,2,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (152,'Main',390,8,2,'15:30:00','19:30:00','N','2004-01-01','3004-12-31',20040406115028,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (153,'Main',390,8,3,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (154,'Main',390,8,3,'15:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (155,'Main',390,8,4,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040406110822,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (156,'Main',390,8,4,'15:30:00','18:15:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (157,'Main',390,8,5,'11:00:00','13:30:00','N','2004-01-01','3004-12-31',20040406115052,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (158,'Main',390,8,5,'16:00:00','17:00:00','N','2004-01-01','3004-12-31',20040406110301,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (159,'Main',4572,8,2,'10:30:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (160,'Main',4572,8,2,'14:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (161,'Main',4572,8,6,'10:30:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (162,'Main',4572,8,6,'15:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (163,'Main',4572,8,4,'10:30:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (164,'Main',4572,8,4,'14:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (165,'Main',4572,8,5,'11:00:00','13:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (166,'Main',125,8,5,'16:45:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (167,'Main',1,8,2,'12:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (168,'Main',1,8,2,'15:30:00','18:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (169,'Main',1,8,3,'10:30:00','14:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (170,'Main',1,8,3,'15:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (171,'Main',1,8,4,'12:00:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (172,'Main',1,8,4,'16:00:00','18:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (173,'Main',1,8,5,'11:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (174,'Main',1,8,5,'15:30:00','18:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (175,'Main',125,8,6,'10:30:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (176,'Main',125,8,6,'17:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (177,'Main',125,8,3,'10:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (178,'Main',125,8,3,'16:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (179,'Main',125,8,4,'10:30:00','12:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (180,'Main',125,8,4,'17:30:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (181,'Main',125,8,5,'11:00:00','13:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (182,'Main',5144,8,2,'13:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (183,'Main',5144,8,3,'16:30:00','19:45:00','N','2004-01-01','3004-12-31',20040403144656,20040331093009);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (184,'Main',157,8,2,'15:30:00','16:45:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (185,'Main',157,8,5,'12:00:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,20040324160038);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (187,'Main',157,8,3,'12:00:00','15:00:00','N','2004-01-01','3004-12-31',20040403144656,20040401181657);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (188,'Main',390,18,4,'18:15:00','19:00:00','N','2004-01-01','3004-12-31',20040403144656,20040402124956);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (189,'Main',390,8,4,'19:00:00','19:30:00','N','2004-01-01','3004-12-31',20040403144656,20040402125104);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (190,'Pending',0,19,2,'14:30:00','14:45:00','N','2004-01-01','3004-12-31',20040403144656,20040402125205);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (191,'Pending',0,19,6,'14:30:00','14:45:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (192,'Pending',0,19,3,'14:30:00','14:45:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (193,'Pending',0,19,4,'14:30:00','14:45:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (194,'Main',6144,21,2,'12:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (195,'Main',6144,21,3,'12:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (196,'Main',6144,21,6,'12:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (197,'Main',6144,21,5,'12:30:00','14:00:00','N','2004-01-01','3004-12-31',20040403144656,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (198,'Main',4572,8,5,'14:00:00','16:45:00','N','2004-01-01','3004-12-31',20040403153327,00000000000000);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (199,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (200,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (201,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (202,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (203,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (204,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (205,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (206,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (207,'ABC',0,22,4,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (208,'ABC',0,22,6,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (209,'ABC',0,23,2,'12:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (210,'ABC',0,23,3,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (211,'ABC',0,23,4,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403160736,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (212,'ABC',0,22,4,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (213,'ABC',0,22,6,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (214,'ABC',0,22,4,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (215,'ABC',0,22,6,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (216,'ABC',0,22,4,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (217,'ABC',0,22,6,'13:00:00','16:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (218,'ABC',0,23,2,'12:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (219,'ABC',0,23,3,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (220,'ABC',0,23,4,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (221,'ABC',0,23,2,'12:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (222,'ABC',0,23,3,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (223,'ABC',0,23,4,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (224,'ABC',0,23,2,'12:00:00','13:30:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (225,'ABC',0,23,3,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (226,'ABC',0,23,4,'18:00:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (227,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (228,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (229,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (230,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (231,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (232,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (233,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (234,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (235,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (236,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (237,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (238,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (239,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (240,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (241,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (242,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (243,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (244,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (245,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (246,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (247,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (248,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (249,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (250,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (251,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (252,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (253,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (254,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (255,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (256,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (257,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (258,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (259,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (260,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (261,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (262,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (263,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (264,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (265,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (266,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (267,'ABC',0,24,2,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (268,'ABC',0,24,2,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (269,'ABC',0,24,3,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (270,'ABC',0,24,3,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (271,'ABC',0,24,4,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (272,'ABC',0,24,5,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (273,'ABC',0,24,6,'11:30:00','15:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);
INSERT INTO WeeklyShifts (id, scheduleName, contactId, jobId, weekday, inTime, outTime, meeting, effective, ineffective, modified, created) VALUES (274,'ABC',0,24,6,'15:30:00','19:00:00','N','2004-01-01','3004-12-31',20040403161644,20040403155235);

--
-- Table structure for table 'Workers'
--

DROP TABLE IF EXISTS Workers;
CREATE TABLE Workers (
  id int(11) NOT NULL default '0',
  sunday double(5,2) NOT NULL default '0.00',
  monday double(5,2) NOT NULL default '0.00',
  tuesday double(5,2) NOT NULL default '8.00',
  wednesday double(5,2) NOT NULL default '8.00',
  thursday double(5,2) NOT NULL default '8.00',
  friday double(5,2) NOT NULL default '8.00',
  saturday double(5,2) NOT NULL default '8.00',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'Workers'
--

INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (1,0.00,0.00,8.00,8.00,8.00,8.00,0.00,20040311092313,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (125,0.00,0.00,0.00,8.00,8.00,8.00,8.00,20040311092805,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (157,0.00,0.00,5.00,6.00,6.50,5.50,0.00,20040330183256,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (390,0.00,0.00,8.00,8.00,8.00,8.00,0.00,20040311092313,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (1795,0.00,0.00,8.00,4.00,8.00,0.00,0.00,20040311100755,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4190,0.00,0.00,6.00,7.00,0.00,7.00,0.00,20040311093257,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4253,0.00,0.00,4.00,4.00,4.00,4.00,4.00,20040311092645,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4572,0.00,0.00,8.00,0.00,8.00,8.00,8.00,20040324104728,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (748,0.00,0.00,0.00,5.00,0.00,5.00,0.00,20040323134630,20040311093532);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (5144,0.00,0.00,8.00,8.00,0.00,8.00,8.00,20040311093035,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (5966,0.00,0.00,4.00,4.00,4.00,4.00,4.00,20040311093945,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (6002,0.00,6.40,6.40,6.40,6.40,6.40,0.00,20040311100859,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (6144,0.00,0.00,8.00,8.00,0.00,8.00,8.00,20040311092913,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (6190,0.00,0.00,8.00,0.00,8.00,8.00,8.00,20040311092857,20040311092313);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (6536,0.00,0.00,5.00,5.00,5.00,0.00,5.00,20040323134630,20040311093900);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (6112,0.00,0.00,5.00,5.00,5.00,0.00,5.00,20040323134630,20040311094042);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (5830,0.00,0.00,0.00,4.00,0.00,8.00,8.00,20040323134630,20040311100729);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (6085,0.00,0.00,3.00,3.00,3.00,3.00,3.00,20040323134630,20040323134558);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (693,1.00,0.00,4.00,0.00,1.00,4.00,0.00,20040323173327,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4019,0.00,0.00,4.00,0.00,0.00,8.00,8.00,20040326185842,00000000000000);

--
-- Table structure for table 'WorkersQualifyForJobs'
--

DROP TABLE IF EXISTS WorkersQualifyForJobs;
CREATE TABLE WorkersQualifyForJobs (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  jobId int(11) NOT NULL default '0',
  inJobDescription enum('N','Y') default 'N',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'WorkersQualifyForJobs'
--

INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (1,1,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (2,1,12,'N',20040327104042,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (3,1,14,'Y',20040327103952,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (4,125,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (5,125,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (6,125,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (7,125,4,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (8,125,5,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (9,125,6,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (10,125,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (11,1,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (12,157,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (13,157,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (14,157,16,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (15,157,1,'Y',20040327103824,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (16,157,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (17,157,5,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (18,157,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (19,1,5,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (20,1795,16,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (21,1,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (22,390,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (23,390,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (24,390,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (25,390,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (26,4190,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (27,4190,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (28,4190,2,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (29,4253,4,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (30,4572,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (31,4572,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (32,4572,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (33,4572,4,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (34,5144,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (35,5144,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (36,5144,1,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (37,5144,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (38,5144,5,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (39,5144,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (40,5830,16,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (41,5966,3,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (42,6002,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (43,6002,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (44,6002,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (45,6002,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (46,6112,2,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (47,6144,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (48,6144,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (49,6144,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (50,6144,5,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (51,6144,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (52,6190,11,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (53,6190,12,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (54,6190,2,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (55,6190,3,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (56,6190,7,'N',20040324104039,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (57,6536,4,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (58,693,17,'Y',20040327103500,20040324104039);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (59,4572,7,'N',20040324104825,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (60,6085,1,'N',20040326170905,20040326170905);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (61,4019,16,'Y',20040327103500,20040326173139);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (62,4572,16,'Y',20040331180446,20040326191445);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (63,748,8,'Y',20040331083932,20040326193547);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (64,6002,8,'Y',20040327103500,20040326194319);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (65,6085,13,'Y',20040327103500,20040326195511);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (66,6112,3,'Y',20040327103500,20040327084553);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (67,5144,16,'N',20040330154345,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (68,6190,16,'N',20040330154355,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (69,390,16,'N',20040330154416,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (70,1,16,'N',20040330154422,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (71,6002,16,'N',20040330154428,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (72,6144,16,'N',20040330154434,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (73,6002,5,'N',20040330184755,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (74,390,5,'N',20040330184759,00000000000000);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (75,6144,8,'Y',20040331083932,20040330212507);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (76,390,8,'Y',20040331084140,20040331084140);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (77,4572,8,'Y',20040331084148,20040331084148);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (78,1,8,'Y',20040331084151,20040331084151);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (79,125,8,'Y',20040331084155,20040331084155);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (80,157,8,'Y',20040331084200,20040331084200);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (81,5144,8,'Y',20040331084208,20040331084208);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (82,4190,8,'Y',20040331084226,20040331084226);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (83,4253,8,'Y',20040331084235,20040331084235);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (84,6190,8,'Y',20040331084253,20040331084253);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (85,1795,8,'Y',20040331084307,20040331084307);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (86,5144,10,'Y',20040402114241,20040402114241);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (87,4572,10,'Y',20040402114247,20040402114247);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (88,6190,10,'Y',20040402114252,20040402114252);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (89,4253,10,'Y',20040402114302,20040402114302);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (90,125,10,'Y',20040402114308,20040402114308);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (91,748,10,'Y',20040402114311,20040402114311);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (92,4190,10,'Y',20040402114317,20040402114317);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (93,390,10,'Y',20040402114328,20040402114328);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (94,1,10,'Y',20040402114332,20040402114332);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (95,1795,10,'Y',20040402114338,20040402114338);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (96,6002,10,'Y',20040402114344,20040402114344);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (97,6144,10,'Y',20040402114349,20040402114349);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (98,157,10,'Y',20040402114352,20040402114352);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (99,390,18,'Y',20040402124629,20040402124629);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (100,4572,20,'Y',20040402124646,20040402124646);
INSERT INTO WorkersQualifyForJobs (id, contactId, jobId, inJobDescription, modified, created) VALUES (101,6144,21,'Y',20040402132640,20040402132640);

