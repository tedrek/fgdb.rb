DROP TABLE Links;
CREATE TABLE Links (
  id integer NOT NULL default nextval('Links_id_seq'),
  modified timestamp default now(),
  url varchar(250) ,
  helptext varchar(100) ,
  linktext varchar(250) ,
  broken varchar(1) check (broken in ('N','Y')) default 'N',
  howto varchar(1) check (howto in ('N','Y')) default 'N',
  external varchar(1) check (external in ('N','Y')) default 'N',
  PRIMARY KEY  (id)
);
DROP TABLE PageLinks;
CREATE TABLE PageLinks (
  id integer NOT NULL default nextval('PageLinks_id_seq'),
  pageId integer NOT NULL default '0',
  linkId integer NOT NULL default '0',
  break varchar(1) check (break in ('N','Y')) default 'N',
  displayorder integer NOT NULL default '0',
  helptext varchar(100) ,
  linktext varchar(250) ,
  PRIMARY KEY  (id)
);
DROP TABLE Pages;
CREATE TABLE Pages (
  id integer NOT NULL default nextval('Pages_id_seq'),
  modified timestamp default now(),
  created timestamp default now(),
  shortname varchar(25) ,
  longname varchar(100) ,
  visible varchar(1) check (visible in ('N','Y')) default 'Y',
  linkId integer NOT NULL default '0',
  displayorder integer NOT NULL default '0',
  helptext varchar(100) ,
  PRIMARY KEY  (id)
);

INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (1,'2004-02-05 10:56:47','2004-01-23 15:28:22','FRONTDESK','Reception&nbsp;Area','Y',72,10,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (2,'2004-02-05 10:56:47','2004-01-23 15:28:49','RECEIVING','Donation&nbsp;Receiving&nbsp;Area','Y',73,20,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (3,'2004-02-05 10:56:47','2004-01-23 15:29:14','TESTING','Gizmo Testing&nbsp;Area','N',74,30,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (4,'2004-02-05 10:56:47','2004-01-23 15:28:13','EVALUATION','System&nbsp;Evaluation&nbsp;Area','N',75,40,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (5,'2004-02-05 10:56:47','2004-01-23 15:28:05','BUILD','Build Area','Y',76,50,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (6,'2004-02-05 10:56:47','2004-01-23 15:28:42','PRINTERS','Printer Repair&nbsp;Area','Y',77,60,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (7,'2004-02-05 10:56:47','2004-01-23 15:28:28','LAB','Lab (the old&nbsp;Classroom)','Y',78,70,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (8,'2004-02-05 10:56:47','2004-01-23 15:29:07','SUPPORT','Technical&nbsp;Support&nbsp;Area','Y',79,80,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (9,'2004-02-05 10:56:47','2004-01-23 15:29:01','STORE','Thrift Store','Y',80,90,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (10,'2004-02-05 10:56:47','2004-01-23 15:28:54','RECYCLING','Recycling&nbsp;Area','N',81,100,'');
INSERT INTO Pages (id, modified, created, shortname, longname, visible, linkId, displayorder, helptext) VALUES (11,'2004-02-05 10:56:47','2004-01-23 15:28:34','OFFICE','Administrative&nbsp;Offices','Y',82,110,'');


INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (1,'2004-01-28 14:31:14','','','','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (2,'2004-01-28 15:16:29','reception/','Instructions for Receptionists','Front Desk Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (3,'2004-04-09 12:20:23','donations/DonationProcessor.php','Donations','Donations','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (4,'2004-04-09 12:22:14','sales/SaleProcessor.php','Sales','Sales','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (5,'2004-01-28 15:17:09','deadtrees/','Forms','Forms','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (6,'2004-01-28 15:17:09','contact/ContactManager.php','Contacts','Contacts','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (7,'2004-01-28 15:17:09','hours/','Volunteer Hours','Volunteer Hours','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (8,'2004-01-28 15:17:09','syscheckout/syscheckout.php','Checkout&nbsp;Script','Checkout Script','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (9,'2004-01-28 15:40:21','','Daily&nbsp;Totals','Daily&nbsp;Totals','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (10,'2004-01-28 15:17:09','reports/members/inSystem.php','Current&nbsp;Adopters','Current Adopters','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (11,'2004-01-28 15:17:09','reports/members/buildersReport.php','Current&nbsp;Builders','Current Builders','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (12,'2004-01-28 15:17:09','reports/members/waitingList.php','Waiting&nbsp;List','Waiting List','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (13,'2004-01-28 15:17:09','reports/members/happyList.php','Happy&nbsp;List','Happy List','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (14,'2004-01-28 15:17:09','reports/donations/donationRptChoose.php','Donation&nbsp;Reports','Donation Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (15,'2004-01-28 15:40:21','','More Reports','More Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (16,'2004-01-28 15:17:09','scratchpad/scratchpad.php','Scratchpad','Scratchpad','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (17,'2004-01-28 15:17:09','receiving/careandfeed.html','Care&nbsp;and&nbsp;Feeding','Care&nbsp;and&nbsp;Feeding','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (18,'2004-01-28 15:17:09','macrecycling.html','Mac&nbsp;Recycling','Mac&nbsp;Recycling','Y','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (19,'2004-01-28 15:17:09','receiving/gizmocloner.html','Cloner&nbsp;Howto','Cloner&nbsp;Howto','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (20,'2004-01-28 15:17:09','receiving/','Other&nbsp;Docs','Other&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (21,'2004-01-28 15:17:09','gizmo/intake.php?action=lookupstart','Find&nbsp;Gizmo','Find&nbsp;Gizmo','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (22,'2004-05-27 17:16:24','gizmo/intake.php?action=select_type','New&nbsp;Gizmo','New&nbsp;Gizmo','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (23,'2004-01-28 15:17:09','deadtrees/receivingform.ps','Receiving&nbsp;Tickets','Receiving&nbsp;Tickets','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (24,'2004-01-28 15:17:09','gizmo/clone.php','Cloner','Cloner','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (25,'2004-01-28 15:17:09','','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (26,'2004-01-28 15:17:09','testing/','Testing&nbsp;Docs','Testing&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (27,'2004-01-28 15:40:21','','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (28,'2004-01-28 15:17:09','evaluation/','Sys&nbsp;Eval&nbsp;Docs','Sys&nbsp;Eval&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (29,'2004-01-28 15:17:09','deadtrees/evalkeeptally.ps','Keeper&nbsp;Tally','Keeper&nbsp;Tally','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (30,'2004-01-28 15:17:09','deadtrees/evalrecycletally.ps','Recycle&nbsp;Tally','Recycle&nbsp;Tally','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (31,'2004-01-28 15:40:21','','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (32,'2004-01-28 15:17:09','building/','Build&nbsp;Docs','Build&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (33,'2004-01-28 15:40:21','','Builder&nbsp;Login','Builder&nbsp;Login','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (34,'2004-01-28 15:40:21','','Quality&nbsp;Control','Quality&nbsp;Control','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (35,'2004-01-28 15:40:21','','System&nbsp;Tracking','System&nbsp;Tracking','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (36,'2004-01-28 15:17:09','http://lists.freegeek.org/listinfo/hardware','Hardware&nbsp;List','Hardware&nbsp;List','Y','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (37,'2004-01-28 15:40:21','reports/system/system-report.php','System&nbsp;Report','System&nbsp;Report','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (38,'2004-01-28 15:40:21','','Other&nbsp;Report','Other&nbsp;Report','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (39,'2004-01-28 15:17:09','printers/','Printer&nbsp;Docs','Printer&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (40,'2004-01-28 15:17:09','http://www.linuxprinting.org','Linux&nbsp;Printing','Linux&nbsp;Printing','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (41,'2004-01-28 15:17:09','http://www.sane-project.org','SANE','SANE','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (42,'2004-01-28 15:17:09','http://localhost:631','CUPS','CUPS','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (43,'2004-01-28 15:40:21','','Report','Other&nbsp;Report','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (44,'2004-01-28 15:17:09','receiving/boxocards.html','Box&nbsp;o\'Cards&nbsp;Howto','Box&nbsp;o\'Cards&nbsp;Howto','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (45,'2004-01-28 15:17:09','receiving/gizmocloner.html','Cloner&nbsp;Howto','Cloner&nbsp;Howto','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (46,'2004-01-28 15:17:09','receiving/','Other&nbsp;Docs','Other&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (47,'2004-01-28 15:17:09','file:///usr/local/freekbox/start.html','FB&nbsp;Start&nbsp;Page','FB&nbsp;Start&nbsp;Page','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (48,'2004-01-28 15:17:09','','Reports','Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (49,'2004-01-28 15:17:09','http://freegeek.org/adopters/faq.html','FAQ','FAQ','Y','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (50,'2004-01-28 15:17:09','support/','Other&nbsp;Docs','Other&nbsp;Docs','Y','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (51,'2004-05-25 12:47:52','http://freegeek.org/adopters/','Adopters\'&nbsp;Page','Adopters\'&nbsp;Page','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (52,'2004-01-28 15:17:09','sales/','Sales&nbsp;Docs','Sales&nbsp;Docs','Y','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (53,'2004-01-28 15:40:21','sales/SaleProcessor.php','Sales&nbsp;Receipts','Sales&nbsp;Receipts','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (54,'2004-01-28 15:17:09','http://www.ebay.com','Search&nbsp;eBay','Search&nbsp;eBay','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (55,'2004-01-28 15:40:21','reports/sales/salesRptChoose.php','Sales&nbsp;Reports','Sales&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (56,'2004-01-28 15:40:21','','More&nbsp;Reports','More&nbsp;Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (57,'2004-01-28 15:17:09','recycling/','Other&nbsp;Docs','Other&nbsp;Docs','N','Y','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (58,'2004-01-28 15:40:21','','Pickups','Pickups','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (59,'2004-01-28 15:40:21','','Pickup&nbsp;Reports','Pickup&nbsp;Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (60,'2004-01-28 15:40:21','','Other&nbsp;Reports','Other&nbsp;Reports','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (61,'2004-01-28 15:40:21','','Enter&nbsp;Income','Enter&nbsp;Income','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (62,'2004-01-28 15:40:21','','Resource&nbsp;Tracking','Resource&nbsp;Tracking','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (63,'2004-01-28 15:40:21','','Sort&nbsp;Names','Sort&nbsp;Names','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (64,'2004-01-28 15:40:21','','Contact&nbsp;Lists','Contact&nbsp;Lists','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (65,'2004-01-28 15:40:21','reports/volunteers/vol-reports-1.php','Volunteer&nbsp;Reports','Volunteer&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (66,'2004-01-28 15:40:21','reports/gizmos/gizmo-reports-1.php','Gizmo&nbsp;Reports','Gizmo&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (67,'2004-01-28 15:40:21','','Intake&nbsp;Lookup','Intake&nbsp;Lookup','Y','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (68,'2004-01-28 15:40:21','reports/office.php','Other&nbsp;Reports','Other&nbsp;Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (69,'2004-01-28 15:17:09','http://lists.freegeek.org/listinfo/freekbox','FreekBox&nbsp;List','FreekBox&nbsp;List','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (70,'2004-01-28 15:17:09','http://lists.freegeek.org/listinfo/support','Support&nbsp;List','Support&nbsp;List','N','N','Y');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (71,'2004-01-28 15:17:09','reports/support','Reports','Reports','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (72,'2004-01-28 15:17:09','frontdesk.php','Front&nbsp;Desk','Front&nbsp;Desk','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (73,'2004-01-28 15:17:09','receiving.php','Receiving','Receiving','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (74,'2004-01-28 15:17:09','testing.php','Testing','Testing','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (75,'2004-01-28 15:17:09','evaluation.php','System&nbsp;Eval','System&nbsp;Eval','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (76,'2004-01-28 15:17:09','build.php','Build','Build','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (77,'2004-01-28 15:17:09','printers.php','Printers','Printers','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (78,'2004-01-28 15:17:09','lab.php','Lab','Lab','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (79,'2004-01-28 15:17:09','support.php','Tech&nbsp;Support','Tech&nbsp;Support','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (80,'2004-01-28 15:17:09','store.php','Store','Store','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (81,'2004-01-28 15:17:09','recycling.php','Recycling','Recycling','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (82,'2004-01-28 15:17:09','office.php','Office','Office','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (83,'2004-03-03 11:50:49','sched/enterID.php','Staff&nbsp;Hours','Staff&nbsp;Hours','N','N','N');
INSERT INTO Links (id, modified, url, helptext, linktext, broken, howto, external) VALUES (84,'2004-03-03 11:50:49','sched/sched.php?SHOWNUMS=1','Staff&nbsp;Schedule','Staff&nbsp;Schedule','N','N','N');

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

