-- MySQL dump 8.21
--
-- Host: localhost    Database: fgdb
---------------------------------------------------------
-- Server version	3.23.49-log

--
-- Table structure for table 'allowedStatuses'
--

DROP TABLE IF EXISTS allowedStatuses;
CREATE TABLE allowedStatuses (
  id int(11) NOT NULL auto_increment,
  oldStatus varchar(15) NOT NULL default '',
  newStatus varchar(15) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY oldStatus (oldStatus),
  KEY newStatus (newStatus)
) TYPE=MyISAM;

--
-- Dumping data for table 'allowedStatuses'
--


INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (1,'Adopted','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (2,'Adopted','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (3,'Adopted','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (4,'Adopted','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (5,'Adopted','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (6,'Adopted','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (7,'Adopted','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (8,'Adopted','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (9,'Adopted','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (10,'Cloned','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (11,'Cloned','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (12,'Cloned','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (13,'Cloned','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (14,'Cloned','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (15,'Cloned','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (16,'Cloned','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (17,'Cloned','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (18,'Cloned','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (19,'ForSale','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (20,'ForSale','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (21,'ForSale','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (22,'ForSale','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (23,'ForSale','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (24,'ForSale','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (25,'ForSale','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (26,'ForSale','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (27,'ForSale','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (28,'GAPped','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (29,'GAPped','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (30,'GAPped','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (31,'GAPped','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (32,'GAPped','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (33,'GAPped','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (34,'GAPped','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (35,'GAPped','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (36,'GAPped','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (37,'Granted','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (38,'Granted','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (39,'Granted','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (40,'Granted','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (41,'Granted','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (42,'Granted','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (43,'Granted','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (44,'Granted','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (45,'Granted','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (46,'Infrastructure','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (47,'Infrastructure','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (48,'Infrastructure','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (49,'Infrastructure','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (50,'Infrastructure','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (51,'Infrastructure','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (52,'Infrastructure','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (53,'Infrastructure','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (54,'Infrastructure','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (55,'Received','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (56,'Received','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (57,'Received','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (58,'Received','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (59,'Received','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (60,'Received','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (61,'Received','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (62,'Received','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (63,'Received','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (64,'Recycled','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (65,'Recycled','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (66,'Recycled','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (67,'Recycled','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (68,'Recycled','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (69,'Recycled','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (70,'Recycled','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (71,'Recycled','Sold');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (72,'Recycled','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (73,'Sold','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (74,'Sold','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (75,'Sold','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (76,'Sold','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (77,'Sold','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (78,'Sold','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (79,'Sold','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (80,'Sold','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (81,'Sold','Stored');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (82,'Stored','Adopted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (83,'Stored','Cloned');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (84,'Stored','ForSale');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (85,'Stored','GAPped');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (86,'Stored','Granted');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (87,'Stored','Infrastructure');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (88,'Stored','Received');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (89,'Stored','Recycled');
INSERT INTO allowedStatuses (id, oldStatus, newStatus) VALUES (90,'Stored','Sold');

