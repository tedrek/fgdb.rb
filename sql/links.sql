-- MySQL dump 8.21
--
-- Host: localhost    Database: fgdb
---------------------------------------------------------
-- Server version	3.23.49-log

--
-- Table structure for table 'Pages'
--

DROP TABLE IF EXISTS Pages;
CREATE TABLE Pages (
  id int(11) NOT NULL auto_increment,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  shortname varchar(25) NOT NULL default '',
  longname varchar(100) NOT NULL default '',
  visible enum('N','Y') default 'Y',
  linkId int(11) NOT NULL default '0',
  displayorder int(2) NOT NULL default '0',
  helptext varchar(100) NOT NULL default '',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'Pages'
--


INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (1,20040205105647,20040123152822,'FRONTDESK','Reception&nbsp;Area','Y',72,10,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (2,20040205105647,20040123152849,'RECEIVING','Donation&nbsp;Receiving&nbsp;Area','Y',73,20,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (3,20040205105647,20040123152914,'TESTING','Gizmo Testing&nbsp;Area','N',74,30,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (4,20040205105647,20040123152813,'EVALUATION','System&nbsp;Evaluation&nbsp;Area','N',75,40,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (5,20040205105647,20040123152805,'BUILD','Build Area','Y',76,50,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (6,20040205105647,20040123152842,'PRINTERS','Printer Repair&nbsp;Area','Y',77,60,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (7,20040205105647,20040123152828,'LAB','Lab (the old&nbsp;Classroom)','Y',78,70,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (8,20040205105647,20040123152907,'SUPPORT','Technical&nbsp;Support&nbsp;Area','Y',79,80,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (9,20040205105647,20040123152901,'STORE','Thrift Store','Y',80,90,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (10,20040205105647,20040123152854,'RECYCLING','Recycling&nbsp;Area','N',81,100,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (11,20040205105647,20040123152834,'OFFICE','Administrative&nbsp;Offices','Y',82,110,'');

--
-- Table structure for table 'Links'
--

DROP TABLE IF EXISTS Links;
CREATE TABLE Links (
  id int(11) NOT NULL auto_increment,
  modified timestamp(14) NOT NULL,
  url varchar(250) NOT NULL default '',
  helptext varchar(100) NOT NULL default '',
  linktext varchar(250) NOT NULL default '',
  broken enum('N','Y') default 'N',
  howto enum('N','Y') default 'N',
  external enum('N','Y') default 'N',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'Links'
--


INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (1,20040128143114,'','','','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (2,20040128151629,'reception/','Instructions for Receptionists','Front Desk Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (3,20040409122023,'donations/DonationProcessor.php','Donations','Donations','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (4,20040409122214,'sales/SaleProcessor.php','Sales','Sales','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (5,20040128151709,'deadtrees/','Forms','Forms','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (6,20040128151709,'contact/ContactManager.php','Contacts','Contacts','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (7,20040128151709,'hours/','Volunteer Hours','Volunteer Hours','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (8,20040128151709,'syscheckout/syscheckout.php','Checkout&nbsp;Script','Checkout Script','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (9,20040609161118,'reports/members/incomeRptChoose.php','Daily&nbsp;Totals','Daily&nbsp;Totals','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (10,20040128151709,'reports/members/inSystem.php','Current&nbsp;Adopters','Current Adopters','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (11,20040128151709,'reports/members/buildersReport.php','Current&nbsp;Builders','Current Builders','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (12,20040128151709,'reports/members/waitingList.php','Waiting&nbsp;List','Waiting List','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (13,20040128151709,'reports/members/happyList.php','Happy&nbsp;List','Happy List','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (14,20040128151709,'reports/donations/donationRptChoose.php','Donation&nbsp;Reports','Donation Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (15,20040128154021,'','More Reports','More Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (16,20040128151709,'scratchpad.php','Scratchpad','Scratchpad','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (17,20040128151709,'receiving/careandfeed.html','Care&nbsp;and&nbsp;Feeding','Care&nbsp;and&nbsp;Feeding','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (18,20040128151709,'macrecycling.html','Mac&nbsp;Recycling','Mac&nbsp;Recycling','Y','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (19,20040128151709,'receiving/gizmocloner.html','Cloner&nbsp;Howto','Cloner&nbsp;Howto','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (20,20040128151709,'receiving/','Other&nbsp;Docs','Other&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (21,20040128151709,'gizmo/intake.php?action=lookupstart','Find&nbsp;Gizmo','Find&nbsp;Gizmo','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (22,20040527171624,'gizmo/intake.php?action=select_type','New&nbsp;Gizmo','New&nbsp;Gizmo','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (23,20040128151709,'deadtrees/receivingform.ps','Receiving&nbsp;Tickets','Receiving&nbsp;Tickets','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (24,20040128151709,'gizmo/clone.php','Cloner','Cloner','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (25,20040128151709,'','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (26,20040128151709,'testing/','Testing&nbsp;Docs','Testing&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (27,20040128154021,'','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (28,20040128151709,'evaluation/','Sys&nbsp;Eval&nbsp;Docs','Sys&nbsp;Eval&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (29,20040128151709,'deadtrees/evalkeeptally.ps','Keeper&nbsp;Tally','Keeper&nbsp;Tally','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (30,20040128151709,'deadtrees/evalrecycletally.ps','Recycle&nbsp;Tally','Recycle&nbsp;Tally','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (31,20040128154021,'','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (32,20040128151709,'building/','Build&nbsp;Docs','Build&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (33,20040128154021,'','Builder&nbsp;Login','Builder&nbsp;Login','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (34,20040128154021,'','Quality&nbsp;Control','Quality&nbsp;Control','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (35,20040128154021,'','System&nbsp;Tracking','System&nbsp;Tracking','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (36,20040128151709,'http://lists.freegeek.org/listinfo/hardware','Hardware&nbsp;List','Hardware&nbsp;List','Y','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (37,20040128154021,'reports/system/system-report.php','System&nbsp;Report','System&nbsp;Report','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (38,20040128154021,'','Other&nbsp;Report','Other&nbsp;Report','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (39,20040128151709,'printers/','Printer&nbsp;Docs','Printer&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (40,20040128151709,'http://www.linuxprinting.org','Linux&nbsp;Printing','Linux&nbsp;Printing','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (41,20040128151709,'http://www.sane-project.org','SANE','SANE','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (42,20040128151709,'http://localhost:631','CUPS','CUPS','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (43,20040128154021,'','Report','Other&nbsp;Report','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (44,20040128151709,'receiving/boxocards.html','Box&nbsp;o\'Cards&nbsp;Howto','Box&nbsp;o\'Cards&nbsp;Howto','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (45,20040128151709,'receiving/gizmocloner.html','Cloner&nbsp;Howto','Cloner&nbsp;Howto','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (46,20040128151709,'receiving/','Other&nbsp;Docs','Other&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (47,20040128151709,'file:///usr/local/freekbox/start.html','FB&nbsp;Start&nbsp;Page','FB&nbsp;Start&nbsp;Page','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (48,20040128151709,'','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (49,20040128151709,'http://freegeek.org/adopters/faq.html','FAQ','FAQ','Y','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (50,20040128151709,'support/','Other&nbsp;Docs','Other&nbsp;Docs','Y','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (51,20040525124752,'http://freegeek.org/adopters/','Adopters\'&nbsp;Page','Adopters\'&nbsp;Page','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (52,20040128151709,'sales/','Sales&nbsp;Docs','Sales&nbsp;Docs','Y','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (53,20040128154021,'sales/SaleProcessor.php','Sales&nbsp;Receipts','Sales&nbsp;Receipts','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (54,20040128151709,'http://www.ebay.com','Search&nbsp;eBay','Search&nbsp;eBay','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (55,20040128154021,'reports/sales/salesRptChoose.php','Sales&nbsp;Reports','Sales&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (56,20040128154021,'','More&nbsp;Reports','More&nbsp;Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (57,20040128151709,'recycling/','Other&nbsp;Docs','Other&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (58,20040128154021,'','Pickups','Pickups','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (59,20040128154021,'','Pickup&nbsp;Reports','Pickup&nbsp;Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (60,20040128154021,'','Other&nbsp;Reports','Other&nbsp;Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (61,20040128154021,'','Enter&nbsp;Income','Enter&nbsp;Income','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (62,20040128154021,'','Resource&nbsp;Tracking','Resource&nbsp;Tracking','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (63,20040128154021,'','Sort&nbsp;Names','Sort&nbsp;Names','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (64,20040128154021,'','Contact&nbsp;Lists','Contact&nbsp;Lists','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (65,20040128154021,'reports/volunteers/vol-reports-1.php','Volunteer&nbsp;Reports','Volunteer&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (66,20040128154021,'reports/gizmos/gizmo-reports-1.php','Gizmo&nbsp;Reports','Gizmo&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (67,20040128154021,'','Intake&nbsp;Lookup','Intake&nbsp;Lookup','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (68,20040128154021,'reports/office.php','Other&nbsp;Reports','Other&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (69,20040128151709,'http://lists.freegeek.org/listinfo/freekbox','FreekBox&nbsp;List','FreekBox&nbsp;List','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (70,20040128151709,'http://lists.freegeek.org/listinfo/support','Support&nbsp;List','Support&nbsp;List','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (71,20040128151709,'reports/support','Reports','Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (72,20040128151709,'frontdesk.php','Front&nbsp;Desk','Front&nbsp;Desk','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (73,20040128151709,'receiving.php','Receiving','Receiving','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (74,20040128151709,'testing.php','Testing','Testing','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (75,20040128151709,'evaluation.php','System&nbsp;Eval','System&nbsp;Eval','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (76,20040128151709,'build.php','Build','Build','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (77,20040128151709,'printers.php','Printers','Printers','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (78,20040128151709,'lab.php','Lab','Lab','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (79,20040128151709,'support.php','Tech&nbsp;Support','Tech&nbsp;Support','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (80,20040128151709,'store.php','Store','Store','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (81,20040128151709,'recycling.php','Recycling','Recycling','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (82,20040128151709,'office.php','Office','Office','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (83,20040303115049,'sched/enterID.php','Staff&nbsp;Hours','Staff&nbsp;Hours','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (84,20040303115049,'sched/sched.php?SHOWNUMS=1','Staff&nbsp;Schedule','Staff&nbsp;Schedule','N','N','N');

--
-- Table structure for table 'PageLinks'
--

DROP TABLE IF EXISTS PageLinks;
CREATE TABLE PageLinks (
  id int(11) NOT NULL auto_increment,
  pageId int(11) NOT NULL default '0',
  linkId int(11) NOT NULL default '0',
  break enum('N','Y') default 'N',
  displayorder int(2) NOT NULL default '0',
  helptext varchar(100) NOT NULL default '',
  linktext varchar(250) NOT NULL default '',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

--
-- Dumping data for table 'PageLinks'
--


INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (1,1,2,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (2,1,1,'Y',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (3,1,3,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (4,1,4,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (5,1,1,'Y',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (6,1,5,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (7,1,1,'Y',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (8,1,6,'N',80,'','Volunteers');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (9,1,7,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (10,1,1,'Y',100,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (11,1,8,'N',110,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (12,1,1,'Y',120,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (13,1,9,'N',130,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (14,1,10,'N',140,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (15,1,11,'N',150,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (16,1,12,'N',160,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (17,1,13,'N',170,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (18,1,14,'N',180,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (19,1,15,'N',190,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (20,1,1,'Y',200,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (21,1,16,'N',210,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (22,2,17,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (23,2,18,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (24,2,19,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (25,2,20,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (26,2,1,'Y',45,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (27,2,21,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (28,2,22,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (29,2,1,'Y',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (30,2,23,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (31,2,1,'Y',75,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (32,2,24,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (33,2,1,'Y',85,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (34,2,25,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (35,2,1,'Y',95,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (36,2,16,'N',100,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (37,3,26,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (38,3,1,'Y',15,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (39,3,5,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (40,3,1,'Y',25,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (41,3,27,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (42,3,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (43,3,16,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (44,4,28,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (45,4,1,'Y',15,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (46,4,29,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (47,4,30,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (48,4,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (49,4,31,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (50,4,1,'Y',45,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (51,4,16,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (52,5,32,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (53,5,1,'Y',15,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (54,5,21,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (55,5,22,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (56,5,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (57,5,33,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (58,5,34,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (59,5,35,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (60,5,1,'Y',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (61,5,36,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (62,5,1,'Y',75,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (63,5,7,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (64,5,1,'Y',85,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (65,5,37,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (66,5,38,'N',100,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (67,5,1,'Y',105,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (68,5,16,'N',110,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (69,6,39,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (70,6,1,'Y',15,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (71,6,40,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (72,6,41,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (73,6,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (74,6,42,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (75,6,1,'Y',45,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (76,6,21,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (77,6,22,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (78,6,1,'Y',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (79,6,43,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (80,6,1,'Y',75,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (81,6,16,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (82,7,44,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (83,7,45,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (84,7,46,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (85,7,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (86,7,21,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (87,7,22,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (88,7,1,'Y',55,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (89,7,8,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (90,7,1,'Y',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (91,7,47,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (92,7,1,'Y',75,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (93,7,24,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (94,7,1,'Y',85,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (95,7,48,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (96,7,1,'Y',95,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (97,7,16,'N',100,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (98,8,49,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (99,8,50,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (100,8,1,'Y',25,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (101,8,51,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (102,8,47,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (103,8,1,'Y',45,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (104,8,69,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (105,8,70,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (106,8,1,'Y',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (107,8,7,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (108,8,1,'Y',75,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (109,8,21,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (110,8,22,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (111,8,1,'Y',95,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (112,8,71,'N',100,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (113,8,1,'Y',105,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (114,8,16,'N',110,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (115,9,52,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (116,9,1,'Y',15,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (117,9,53,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (118,9,1,'Y',25,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (119,9,54,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (120,9,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (121,9,21,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (122,9,22,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (123,9,1,'Y',55,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (124,9,9,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (125,9,55,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (126,9,56,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (127,9,1,'Y',85,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (128,9,16,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (129,10,45,'N',10,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (130,10,57,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (131,10,1,'Y',25,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (132,10,58,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (133,10,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (134,10,21,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (135,10,22,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (136,10,1,'Y',55,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (137,10,24,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (138,10,1,'Y',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (139,10,59,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (140,10,60,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (141,10,1,'Y',85,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (142,10,16,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (143,11,6,'N',10,'','Find&nbsp;Contact');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (144,11,1,'Y',15,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (145,11,61,'N',20,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (146,11,1,'Y',25,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (147,11,62,'N',30,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (148,11,1,'Y',35,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (149,11,5,'N',40,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (150,11,1,'Y',45,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (151,11,63,'N',50,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (152,11,1,'Y',55,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (153,11,64,'N',60,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (154,11,65,'N',70,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (155,11,7,'N',80,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (156,11,66,'N',90,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (157,11,67,'N',100,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (158,11,9,'N',110,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (159,11,68,'N',120,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (160,11,1,'Y',125,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (161,11,16,'N',130,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (162,11,83,'N',65,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (163,11,84,'N',66,'','');
INSERT INTO PageLinks (id, pageId, linkId, break, displayorder, helptext, linktext) VALUES (164,1,1,'Y',35,'','');

