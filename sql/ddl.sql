
DROP TABLE IF EXISTS Borrow;
CREATE TABLE Borrow (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  gizmoId int(11) NOT NULL default '0',
  borrowDate date NOT NULL default '0000-00-00',
  returnDate date NOT NULL default '0000-00-00',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS CDDrive;
CREATE TABLE CDDrive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  interface varchar(10) default '',
  speed varchar(10) default '',
  writeMode varchar(15) default '',
  scsi enum('N','Y') default 'N',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Card;
CREATE TABLE Card (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  slotType varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Component;
CREATE TABLE Component (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  inSysId int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Contact;
CREATE TABLE Contact (
  id int(11) NOT NULL auto_increment,
  waiting enum('N','Y') default 'N',
  member enum('N','Y') default 'N',
  volunteer enum('N','Y') default 'N',
  donor enum('N','Y') default 'N',
  buyer enum('N','Y') default 'N',
  contactType enum('O','P') NOT NULL default 'P',
  firstname varchar(25) NOT NULL default '',
  middlename varchar(25) NOT NULL default '',
  lastname varchar(50) NOT NULL default '',
  organization varchar(50) NOT NULL default '',
  address varchar(50) NOT NULL default '',
  address2 varchar(50) NOT NULL default '',
  city varchar(30) NOT NULL default 'Portland',
  state char(2) default 'OR',
  zip varchar(10) NOT NULL default '',
  phone varchar(20) NOT NULL default '',
  fax varchar(20) NOT NULL default '',
  email varchar(50) NOT NULL default '',
  emailOK enum('N','Y') NOT NULL default 'Y',
  mailOK enum('N','Y') NOT NULL default 'Y',
  phoneOK enum('N','Y') NOT NULL default 'Y',
  faxOK enum('N','Y') NOT NULL default 'Y',
  notes text NOT NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  sortName varchar(25) NOT NULL default '',
  preferEmail enum('N','Y') NOT NULL default 'N',
  comp4kids enum('N','Y') NOT NULL default 'N',
  recycler enum('N','Y') default 'N',
  grantor enum('N','Y') default 'N',
  build enum('N','Y') default 'N',
  adopter enum('N','Y') NOT NULL default 'N',
  PRIMARY KEY  (id),
  KEY fullname (lastname,middlename,firstname)
) TYPE=MyISAM;

DROP TABLE IF EXISTS ContactList;
CREATE TABLE ContactList (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  listName varchar(20) NOT NULL default '',
  putOnList date default NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  removedFromList date default NULL,
  active enum('Y','N') default 'Y',
  remarks text NOT NULL,
  PRIMARY KEY  (id),
  KEY ContactId (contactId)
) TYPE=MyISAM;

DROP TABLE IF EXISTS ControllerCard;
CREATE TABLE ControllerCard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  numSerial int(1) NOT NULL default '0',
  numParallel int(1) NOT NULL default '0',
  numIDE int(1) NOT NULL default '0',
  floppy enum('N','Y') NOT NULL default 'Y',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

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

DROP TABLE IF EXISTS Donation;
CREATE TABLE Donation (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  contactType enum('O','P') NOT NULL default 'P',
  firstname varchar(25) NOT NULL default '',
  middlename varchar(25) NOT NULL default '',
  lastname varchar(50) NOT NULL default '',
  organization varchar(50) NOT NULL default '',
  address varchar(50) NOT NULL default '',
  address2 varchar(50) NOT NULL default '',
  city varchar(30) NOT NULL default 'Portland',
  state char(2) default 'OR',
  zip varchar(10) NOT NULL default '',
  phone varchar(20) NOT NULL default '',
  email varchar(50) NOT NULL default '',
  emailOK enum('N','Y') NOT NULL default 'Y',
  mailOK enum('N','Y') NOT NULL default 'Y',
  phoneOK enum('N','Y') NOT NULL default 'Y',
  cashDonation double(8,2) NOT NULL default '0.00',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  sortName varchar(25) default NULL,
  mbrPayment enum('N','Y') NOT NULL default 'N',
  comp4kids enum('N','Y') NOT NULL default 'N',
  monitorFee double(8,2) default '0.00',
  PRIMARY KEY  (id),
  KEY fullname (lastname,middlename,firstname)
) TYPE=MyISAM;

DROP TABLE IF EXISTS DonationLine;
CREATE TABLE DonationLine (
  id int(11) NOT NULL auto_increment,
  donationId int(11) NOT NULL default '0',
  description text NOT NULL,
  quantity int(11) NOT NULL default '1',
  PRIMARY KEY  (id),
  KEY donationId (donationId)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Drive;
CREATE TABLE Drive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS FloppyDrive;
CREATE TABLE FloppyDrive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  diskSize varchar(10) default NULL,
  capacity varchar(10) default NULL,
  cylinders int(8) default '0',
  heads int(5) default '0',
  sectors int(10) default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Gizmo;
CREATE TABLE Gizmo (
  id int(11) NOT NULL auto_increment,
  classTree varchar(100) NOT NULL default '',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  oldStatus varchar(15) NOT NULL default '',
  newStatus varchar(15) NOT NULL default 'Received',
  obsolete enum('N','Y','M') NOT NULL default 'N',
  working enum('N','Y','M') NOT NULL default 'M',
  architecture varchar(10) NOT NULL default 'PC',
  manufacturer varchar(50) NOT NULL default '',
  modelNumber varchar(50) NOT NULL default '',
  location varchar(10) NOT NULL default 'Free Geek',
  notes text NOT NULL,
  testData enum('N','Y') default 'N',
  value double(5,1) NOT NULL default '0.0',
  inventoried timestamp(14) NOT NULL,
  builderId int(11) NOT NULL default '0',
  inspectorId int(11) NOT NULL default '0',
  linuxfund enum('N','Y','M') NOT NULL default 'N',
  cashValue double(8,2) NOT NULL default '0.00',
  needsExpert enum('N','Y') default 'N',
  gizmoType varchar(10) default 'Other',
  adopterId int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY needsExpert (needsExpert),
  KEY architecture (architecture),
  KEY oldStatus (oldStatus),
  KEY newStatus (newStatus)
) TYPE=MyISAM;

DROP TABLE IF EXISTS GizmoClones;
CREATE TABLE GizmoClones (
  id int(11) NOT NULL auto_increment,
  parentId int(11) NOT NULL default '0',
  childId int(11) NOT NULL default '0',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id),
  KEY parentId (parentId),
  KEY childId (childId)
) TYPE=MyISAM;

DROP TABLE IF EXISTS GizmoStatusChanges;
CREATE TABLE GizmoStatusChanges (
  id int(11) NOT NULL default '0',
  oldStatus varchar(15) NOT NULL default '',
  newStatus varchar(15) NOT NULL default '',
  created timestamp(14) NOT NULL,
  change_id int(11) NOT NULL auto_increment,
  PRIMARY KEY  (change_id),
  KEY oldStatus (oldStatus),
  KEY newStatus (newStatus),
  KEY id (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Holidays;
CREATE TABLE Holidays (
  id int(11) NOT NULL auto_increment,
  name varchar(50) NOT NULL default '',
  holiday date default NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS IDEHardDrive;
CREATE TABLE IDEHardDrive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  cylinders int(8) NOT NULL default '0',
  heads int(5) NOT NULL default '0',
  sectors int(10) NOT NULL default '0',
  ata varchar(10) NOT NULL default '',
  sizeMb int(7) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

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

DROP TABLE IF EXISTS Jobs;
CREATE TABLE Jobs (
  id int(11) NOT NULL auto_increment,
  job varchar(50) NOT NULL default '',
  scheduleName varchar(15) NOT NULL default 'Main',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Keyboard;
CREATE TABLE Keyboard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  kbType varchar(10) default NULL,
  numKeys varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

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

DROP TABLE IF EXISTS Materials;
CREATE TABLE Materials (
  id int(11) NOT NULL auto_increment,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  materialName varchar(25) NOT NULL default '',
  rateBase enum('W','P') default 'W',
  defaultUnit varchar(20) NOT NULL default '',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Member;
CREATE TABLE Member (
  id int(11) NOT NULL default '0',
  memberType enum('V','M','N') default 'M',
  howFoundOut text,
  interestComputer enum('N','Y') NOT NULL default 'N',
  interestClasses enum('N','Y') NOT NULL default 'N',
  interestAccess enum('N','Y') NOT NULL default 'N',
  skillHardware enum('N','Y') NOT NULL default 'N',
  textHardware text,
  skillNetwork enum('N','Y') NOT NULL default 'N',
  textNetwork text,
  skillLinux enum('N','Y') NOT NULL default 'N',
  textLinux text,
  skillSoftware enum('N','Y') NOT NULL default 'N',
  textSoftware text,
  skillTeaching enum('N','Y') NOT NULL default 'N',
  textTeaching text,
  skillOtherComputer enum('N','Y') NOT NULL default 'N',
  textOtherComputer text,
  skillAdmin enum('N','Y') NOT NULL default 'N',
  textAdmin text,
  skillConstruction enum('N','Y') NOT NULL default 'N',
  textConstruction text,
  skillVolunteerCoord enum('N','Y') NOT NULL default 'N',
  textVolunteerCoord text,
  skillOther enum('N','Y') NOT NULL default 'N',
  textOther text,
  notes text,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS MemberHour;
CREATE TABLE MemberHour (
  id int(11) NOT NULL auto_increment,
  memberId int(11) NOT NULL default '0',
  workDate date default NULL,
  inTime time default NULL,
  outTime time default NULL,
  jobType varchar(15) NOT NULL default '',
  jobDescription text,
  hours double(5,2) NOT NULL default '0.00',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  payType enum('V','W','H','O') NOT NULL default 'V',
  PRIMARY KEY  (id),
  KEY memberId (memberId)
) TYPE=MyISAM;

DROP TABLE IF EXISTS MiscCard;
CREATE TABLE MiscCard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  miscNotes text,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS MiscComponent;
CREATE TABLE MiscComponent (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  miscNotes text,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS MiscDrive;
CREATE TABLE MiscDrive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  miscNotes text,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS MiscGizmo;
CREATE TABLE MiscGizmo (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Modem;
CREATE TABLE Modem (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  speed varchar(15) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS ModemCard;
CREATE TABLE ModemCard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  speed varchar(15) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Monitor;
CREATE TABLE Monitor (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  size varchar(10) NOT NULL default '',
  resolution varchar(10) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS NetworkCard;
CREATE TABLE NetworkCard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  speed varchar(10) NOT NULL default '',
  rj45 enum('N','Y') NOT NULL default 'N',
  aux enum('N','Y') NOT NULL default 'N',
  bnc enum('N','Y') NOT NULL default 'N',
  thicknet enum('N','Y') NOT NULL default 'N',
  module varchar(50) NOT NULL default '',
  io varchar(10) NOT NULL default '',
  irq char(2) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS NetworkingDevice;
CREATE TABLE NetworkingDevice (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  speed varchar(10) NOT NULL default '',
  rj45 enum('N','Y') NOT NULL default 'N',
  aux enum('N','Y') NOT NULL default 'N',
  bnc enum('N','Y') NOT NULL default 'N',
  thicknet enum('N','Y') NOT NULL default 'N',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Organization;
CREATE TABLE Organization (
  id int(11) NOT NULL default '0',
  contactId int(11) NOT NULL default '0',
  missionStatement text,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id),
  KEY contactId (contactId)
) TYPE=MyISAM;

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

DROP TABLE IF EXISTS PickupLines;
CREATE TABLE PickupLines (
  id int(11) NOT NULL auto_increment,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  pickupId int(11) NOT NULL default '0',
  materialId int(11) NOT NULL default '0',
  pickupUnitType varchar(20) NOT NULL default '',
  processedUnitType varchar(20) NOT NULL default '',
  pickupUnitCount int(3) NOT NULL default '1',
  processedUnitCount int(3) NOT NULL default '1',
  pickupWeight double(10,2) NOT NULL default '0.00',
  processedWeight double(10,2) NOT NULL default '0.00',
  amountCharged double(10,2) NOT NULL default '0.00',
  rate double(10,4) NOT NULL default '0.0000',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Pickups;
CREATE TABLE Pickups (
  id int(11) NOT NULL auto_increment,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  vendorId int(11) NOT NULL default '0',
  pickupDate date NOT NULL default '0000-00-00',
  receiptNumber varchar(20) NOT NULL default '',
  settlementNumber varchar(20) NOT NULL default '',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS PointingDevice;
CREATE TABLE PointingDevice (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  connector varchar(10) default NULL,
  pointerType varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS PowerSupply;
CREATE TABLE PowerSupply (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  watts int(4) NOT NULL default '0',
  connection varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Printer;
CREATE TABLE Printer (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  speedppm int(2) NOT NULL default '0',
  printerType varchar(10) default NULL,
  interface varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Processor;
CREATE TABLE Processor (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  chipClass varchar(15) NOT NULL default '',
  interface varchar(10) default NULL,
  speed int(6) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS SCSICard;
CREATE TABLE SCSICard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  internalInterface varchar(15) default NULL,
  externalInterface varchar(15) default NULL,
  parms text,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS SCSIHardDrive;
CREATE TABLE SCSIHardDrive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  sizeMb int(7) NOT NULL default '0',
  scsiVersion varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
  id int(11) NOT NULL auto_increment,
  contactId int(11) NOT NULL default '0',
  contactType enum('O','P') NOT NULL default 'P',
  firstname varchar(25) NOT NULL default '',
  middlename varchar(25) NOT NULL default '',
  lastname varchar(50) NOT NULL default '',
  organization varchar(50) NOT NULL default '',
  address varchar(50) NOT NULL default '',
  address2 varchar(50) NOT NULL default '',
  city varchar(30) NOT NULL default 'Portland',
  state char(2) default 'OR',
  zip varchar(10) NOT NULL default '',
  phone varchar(20) NOT NULL default '',
  email varchar(50) NOT NULL default '',
  emailOK enum('N','Y') NOT NULL default 'Y',
  mailOK enum('N','Y') NOT NULL default 'Y',
  phoneOK enum('N','Y') NOT NULL default 'Y',
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  subtotal double(8,2) NOT NULL default '0.00',
  discount double(8,2) NOT NULL default '0.00',
  total double(8,2) NOT NULL default '0.00',
  sortname varchar(25) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY fullname (lastname,middlename,firstname)
) TYPE=MyISAM;

DROP TABLE IF EXISTS SalesLine;
CREATE TABLE SalesLine (
  id int(11) NOT NULL auto_increment,
  salesId int(11) NOT NULL default '0',
  gizmoId int(11) NOT NULL default '0',
  description text NOT NULL,
  cashValue double(8,2) NOT NULL default '0.00',
  subtotal double(8,2) NOT NULL default '0.00',
  discount double(8,2) NOT NULL default '0.00',
  total double(8,2) NOT NULL default '0.00',
  merchType varchar(15) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY salesId (salesId),
  KEY gizmoId (gizmoId)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Scanner;
CREATE TABLE Scanner (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  interface varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

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

DROP TABLE IF EXISTS SoundCard;
CREATE TABLE SoundCard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  soundType varchar(15) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Speaker;
CREATE TABLE Speaker (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  powered enum('N','Y') NOT NULL default 'N',
  subwoofer enum('N','Y') NOT NULL default 'N',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS System;
CREATE TABLE System (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  systemConfiguration text,
  systemBoard text,
  adapterInformation text,
  multiprocessorInformation text,
  displayDetails text,
  displayInformation text,
  scsiInformation text,
  pcmciaInformation text,
  modemInformation text,
  multimediaInformation text,
  plugNplayInformation text,
  physicalDrives text,
  ram int(7) default NULL,
  videoRAM int(7) default NULL,
  sizeMb int(7) default NULL,
  scsi enum('N','Y') default 'N',
  chipClass varchar(15) NOT NULL default '',
  speed int(6) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS SystemBoard;
CREATE TABLE SystemBoard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  pciSlots int(2) NOT NULL default '0',
  vesaSlots int(2) NOT NULL default '0',
  isaSlots int(2) NOT NULL default '0',
  eisaSlots int(2) NOT NULL default '0',
  agpSlot enum('N','Y') default 'N',
  ram30pin int(2) NOT NULL default '0',
  ram72pin int(2) NOT NULL default '0',
  ram168pin int(2) NOT NULL default '0',
  dimmSpeed varchar(10) NOT NULL default '',
  proc386 int(2) NOT NULL default '0',
  proc486 int(2) NOT NULL default '0',
  proc586 int(2) NOT NULL default '0',
  procMMX int(2) NOT NULL default '0',
  procPRO int(2) NOT NULL default '0',
  procSocket7 int(2) NOT NULL default '0',
  procSlot1 int(2) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS SystemCase;
CREATE TABLE SystemCase (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  caseType varchar(10) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS TapeDrive;
CREATE TABLE TapeDrive (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  interface varchar(15) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Unit2Material;
CREATE TABLE Unit2Material (
  id int(11) NOT NULL auto_increment,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  materialId int(11) NOT NULL default '0',
  unitType varchar(20) NOT NULL default '',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users (
  id int(11) NOT NULL auto_increment,
  username varchar(50) NOT NULL default '',
  password varchar(50) NOT NULL default '',
  usergroup varchar(50) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY username (username)
) TYPE=MyISAM;

DROP TABLE IF EXISTS VideoCard;
CREATE TABLE VideoCard (
  id int(11) NOT NULL default '0',
  classTree varchar(100) NOT NULL default '',
  videoMemory varchar(10) default NULL,
  resolutions text,
  PRIMARY KEY  (id),
  KEY classTree (classTree)
) TYPE=MyISAM;

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
  PRIMARY KEY  (id)
) TYPE=MyISAM;

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

DROP TABLE IF EXISTS allowedStatuses;
CREATE TABLE allowedStatuses (
  id int(11) NOT NULL auto_increment,
  oldStatus varchar(15) NOT NULL default '',
  newStatus varchar(15) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY oldStatus (oldStatus),
  KEY newStatus (newStatus)
) TYPE=MyISAM;

DROP TABLE IF EXISTS anonDict;
CREATE TABLE anonDict (
  id int(11) NOT NULL auto_increment,
  dictType int(11) default NULL,
  value varchar(50) default NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS answers;
CREATE TABLE answers (
  id int(11) NOT NULL auto_increment,
  fk_sess_id int(11) default NULL,
  qnum smallint(6) default NULL,
  ansr varchar(255) default NULL,
  fk_questions_id smallint(6) default NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS classTree;
CREATE TABLE classTree (
  id int(11) NOT NULL auto_increment,
  classTree varchar(100) NOT NULL default '',
  tableName varchar(50) NOT NULL default '',
  level int(11) default NULL,
  instantiable enum('N','Y') NOT NULL default 'Y',
  intakeCode varchar(10) default NULL,
  intakeAdd int(4) default NULL,
  description varchar(50) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY classTree (classTree),
  KEY tableName (tableName)
) TYPE=MyISAM;

DROP TABLE IF EXISTS codedInfo;
CREATE TABLE codedInfo (
  id int(11) NOT NULL auto_increment,
  codeType varchar(100) NOT NULL default '',
  codeLength int(2) default '10',
  code varchar(25) NOT NULL default '',
  description text NOT NULL,
  modified timestamp(14) NOT NULL,
  created timestamp(14) NOT NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS defaultValues;
CREATE TABLE defaultValues (
  id int(11) NOT NULL auto_increment,
  classTree varchar(100) NOT NULL default '',
  fieldName varchar(50) NOT NULL default '',
  defaultValue varchar(50) default NULL,
  PRIMARY KEY  (id),
  KEY classTree (classTree),
  KEY fieldName (fieldName)
) TYPE=MyISAM;

DROP TABLE IF EXISTS fieldMap;
CREATE TABLE fieldMap (
  id int(11) NOT NULL auto_increment,
  tableName varchar(50) NOT NULL default '',
  fieldName varchar(50) NOT NULL default '',
  displayOrder int(11) NOT NULL default '0',
  inputWidget varchar(50) default NULL,
  inputWidgetParameters varchar(100) default NULL,
  outputWidget varchar(50) default NULL,
  outputWidgetParameters varchar(100) default NULL,
  editable enum('N','Y') default 'Y',
  helpLink enum('N','Y') default 'N',
  description varchar(100) NOT NULL default '',
  PRIMARY KEY  (id),
  KEY tableName (tableName),
  KEY fieldName (fieldName),
  KEY displayOrder (displayOrder)
) TYPE=MyISAM;

DROP TABLE IF EXISTS helpScreen;
CREATE TABLE helpScreen (
  id int(11) NOT NULL auto_increment,
  tableName varchar(50) NOT NULL default '',
  fieldName varchar(50) NOT NULL default '',
  displayOrder int(11) NOT NULL default '0',
  helpText text NOT NULL,
  imageURL text NOT NULL,
  PRIMARY KEY  (id),
  KEY tableName (tableName),
  KEY fieldName (fieldName),
  KEY displayOrder (displayOrder)
) TYPE=MyISAM;

DROP TABLE IF EXISTS options;
CREATE TABLE options (
  id int(11) NOT NULL auto_increment,
  fk_qid int(11) default NULL,
  qopts text,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id int(11) NOT NULL auto_increment,
  qtext text,
  qhint text,
  qnum tinyint(4) default NULL,
  qname varchar(16) default NULL,
  qtype varchar(4) default NULL,
  qargx varchar(50) default NULL,
  qatxt varchar(50) default NULL,
  qsrc varchar(4) default NULL,
  qgrp varchar(25) default NULL,
  active tinyint(1) default NULL,
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS relations;
CREATE TABLE relations (
  id int(11) NOT NULL auto_increment,
  parentTable varchar(50) NOT NULL default '',
  parentField varchar(50) NOT NULL default '',
  parentMultiplicity varchar(10) NOT NULL default '',
  childTable varchar(50) NOT NULL default '',
  childField varchar(50) NOT NULL default '',
  childMultiplicity varchar(10) NOT NULL default '',
  PRIMARY KEY  (id)
) TYPE=MyISAM;

DROP TABLE IF EXISTS sessions;
CREATE TABLE sessions (
  id int(11) NOT NULL auto_increment,
  sysid varchar(10) default NULL,
  status tinyint(4) default NULL,
  nextq int(11) default NULL,
  boxtype varchar(20) default NULL,
  mtime varchar(50) default NULL,
  isold enum('Y','N') default 'N',
  PRIMARY KEY  (id)
) TYPE=MyISAM;
