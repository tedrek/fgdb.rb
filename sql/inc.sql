-- MySQL dump 8.21
--
-- Host: localhost    Database: fgdb
---------------------------------------------------------
-- Server version	3.23.49-log

--
-- Table structure for table 'Income'
--

DROP TABLE IF EXISTS Income;
CREATE TABLE Income (
  id int(11) NOT NULL auto_increment,
  incomeType varchar(10) NOT NULL default '',
  description varchar(50) NOT NULL default '',
  received date default NULL,
  amount double(8,2) NOT NULL default '0.00',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  contactId int(11) NOT NULL default '0',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'Income'
--


INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Grant','',
'2004-06-01',100.00,20040409183952,20040409183952,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Embezzlement','',
'2004-06-02',100.00,20040409183952,20040409183952,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Extortion','',
'2004-06-03',100.00,20040409183952,20040409183952,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Recycling','Hallmark Refining Corp ECB',
'2004-06-10',2145.75,20030621161843,20030621161843,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Recycling','Hallmark Refining Corp ECB',
'2004-06-11',2145.75,20030621161843,20030621161843,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Recycling','Hallmark Refining Corp ECB',
'2004-06-12',2145.75,20030621161843,20030621161843,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Recycling','Quantum Resource Recovery',
'2004-06-13',558.10,20030624152308,20030624152308,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Recycling','Quantum Resource Recovery',
'2004-06-14',558.10,20030624152308,20030624152308,0);
INSERT INTO Income (incomeType, description, received, amount, modified, created, contactId) VALUES ('Recycling','Quantum Resource Recovery',
'2004-06-15',558.10,20030624152308,20030624152308,0);
