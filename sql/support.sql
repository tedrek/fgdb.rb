DROP TABLE IF EXISTS Issues;
CREATE TABLE Issues (
  id int(11) NOT NULL default '0',
  contactId int(11) NOT NULL default '0',
  gizmoId int(11) NOT NULL default '0',
	issuename varchar(100) NOT NULL default '',
	issuestatus varchar(10) NOT NULL default '',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS IssueNotes;
CREATE TABLE IssueNotes (
  id int(11) NOT NULL default '0',
  issueId int(11) NOT NULL default '0',
  techname varchar(25) NOT NULL default '',
  notes text NOT NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

