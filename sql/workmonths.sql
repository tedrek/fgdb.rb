-- MySQL dump 8.21
--
-- Host: localhost    Database: libermanm
---------------------------------------------------------
-- Server version	3.23.49-log

--
-- Table structure for table 'WorkMonths'
--

DROP TABLE IF EXISTS WorkMonths;
CREATE TABLE WorkMonths (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  work_year int(11) NOT NULL default '2004',
  work_month int(11) NOT NULL default '1',
  day_01 double(5,2) NOT NULL default '0.00',
  day_02 double(5,2) NOT NULL default '0.00',
  day_03 double(5,2) NOT NULL default '0.00',
  day_04 double(5,2) NOT NULL default '0.00',
  day_05 double(5,2) NOT NULL default '0.00',
  day_06 double(5,2) NOT NULL default '0.00',
  day_07 double(5,2) NOT NULL default '0.00',
  day_08 double(5,2) NOT NULL default '0.00',
  day_09 double(5,2) NOT NULL default '0.00',
  day_10 double(5,2) NOT NULL default '0.00',
  day_11 double(5,2) NOT NULL default '0.00',
  day_12 double(5,2) NOT NULL default '0.00',
  day_13 double(5,2) NOT NULL default '0.00',
  day_14 double(5,2) NOT NULL default '0.00',
  day_15 double(5,2) NOT NULL default '0.00',
  day_16 double(5,2) NOT NULL default '0.00',
  day_17 double(5,2) NOT NULL default '0.00',
  day_18 double(5,2) NOT NULL default '0.00',
  day_19 double(5,2) NOT NULL default '0.00',
  day_20 double(5,2) NOT NULL default '0.00',
  day_21 double(5,2) NOT NULL default '0.00',
  day_22 double(5,2) NOT NULL default '0.00',
  day_23 double(5,2) NOT NULL default '0.00',
  day_24 double(5,2) NOT NULL default '0.00',
  day_25 double(5,2) NOT NULL default '0.00',
  day_26 double(5,2) NOT NULL default '0.00',
  day_27 double(5,2) NOT NULL default '0.00',
  day_28 double(5,2) NOT NULL default '0.00',
  day_29 double(5,2) NOT NULL default '0.00',
  day_30 double(5,2) NOT NULL default '0.00',
  day_31 double(5,2) NOT NULL default '0.00',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY contactyearmonth (contactId,work_year,work_month)
) TYPE=MyISAM;

--
-- Dumping data for table 'WorkMonths'
--



