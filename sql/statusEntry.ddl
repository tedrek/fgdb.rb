
DROP TABLE IF EXISTS StatusSheet;
CREATE TABLE StatusSheet (
    id int(11) NOT NULL auto_increment,
    volunteerId int(11) NOT NULL,
    programId int (11) NOT NULL,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS StatusEntry;
CREATE TABLE StatusEntry (
    id int(11) NOT NULL auto_increment,
    statusSheetId int(11) NOT NULL,
    instructorId int(11) NOT NULL,
    completionDate date default NULL,
    actionId int(11) NOT NULL,
    comments TEXT,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS programStatusMap;
CREATE TABLE programStatusMap (
    id int(11) NOT NULL auto_increment,
    programName TEXT,
    PRIMARY KEY (id)
);

DROP TABLE IF EXISTS actionStatusMap;
CREATE TABLE actionStatusMap (
    id int(11) NOT NULL auto_increment,
    programId int(11) NOT NULL,
    actionName TEXT,
  --  allowMultiple  default 'F',
    PRIMARY KEY (id)
);

INSERT INTO programStatusMap (programName) VALUES ('Build');
INSERT INTO programStatusMap (programName) VALUES ('Advanced Build');

INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'In Database');
INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'Card Sorting');
INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'Motherboard Sorting');
INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'System Evaluation I');
INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'System Evaluation II');
INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'Command Line Class');

INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'QC');
INSERT INTO actionStatusMap (programId, actionName) VALUES (1, 'Build');

--INSERT INTO actionStatusMap (programId, actionName, allowMultiple) VALUES (1, 'QC', 'T');
--INSERT INTO actionStatusMap (programId, actionName, allowMultiple) VALUES (1, 'Build', 'T');

