-- MySQL dump 8.21
--
-- Host: localhost    Database: fgdbtest
---------------------------------------------------------
-- Server version	3.23.49-log

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


INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4400,0.00,0.00,0.00,8.00,8.00,8.00,8.00,20031006101606,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4401,0.00,0.00,8.00,0.00,8.00,8.00,8.00,20031006101610,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4402,0.00,0.00,8.00,8.00,0.00,8.00,8.00,20031006101612,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4411,0.00,0.00,8.00,8.00,8.00,8.00,0.00,20031006102101,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4404,0.00,0.00,0.00,8.00,8.00,8.00,8.00,20031006101618,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4405,0.00,0.00,8.00,0.00,8.00,8.00,8.00,20031006101620,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4406,0.00,0.00,8.00,8.00,0.00,8.00,8.00,20031006101623,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4407,0.00,0.00,8.00,8.00,8.00,8.00,0.00,20031006101626,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4409,0.00,0.00,0.00,4.00,0.00,8.00,8.00,20031006101637,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4412,0.00,0.00,8.00,0.00,4.00,8.00,0.00,20031006102058,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4413,0.00,0.00,0.00,8.00,0.00,8.00,4.00,20031006102053,00000000000000);
INSERT INTO Workers (id, sunday, monday, tuesday, wednesday, thursday, friday, saturday, modified, created) VALUES (4410,0.00,0.00,8.00,0.00,8.00,4.00,0.00,20031006102104,00000000000000);

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


