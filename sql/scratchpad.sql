-- MySQL dump 8.21
--
-- Host: localhost    Database: rfs
---------------------------------------------------------
-- Server version	3.23.49-log

--
-- Table structure for table 'ScratchPad'
--

DROP TABLE IF EXISTS ScratchPad;
CREATE TABLE ScratchPad (
  id int(11) NOT NULL auto_increment,
  pageId int(11) NOT NULL default '0',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  contactId int(11) NOT NULL default '0',
  name varchar(25) NOT NULL default '',
  note text NOT NULL,
  urgent enum('N','Y') default 'N',
  visible enum('N','Y') default 'Y',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'ScratchPad'
--


INSERT INTO ScratchPad (id, pageId, modified, created, contactId,
name, note, urgent, visible) VALUES (1,1,20040123171515,20040123171459,0,'Richard','Hey there! Isn\'t this cool?','N','Y');

