DROP TABLE Borrow;
CREATE TABLE Borrow (
  id integer NOT NULL default nextval('Borrow_id_seq'),
  contactId integer NOT NULL default '0',
  gizmoId integer NOT NULL default '0',
  borrowDate date NOT NULL ,
  returnDate date NOT NULL ,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE CDDrive;
CREATE TABLE CDDrive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  interface varchar(10) default '',
  speed varchar(10) default '',
  writeMode varchar(15) default '',
  scsi varchar(1) check (scsi in ('N','Y')) default 'N',
  PRIMARY KEY  (id)

);
DROP TABLE Card;
CREATE TABLE Card (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  slotType varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Component;
CREATE TABLE Component (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  inSysId integer NOT NULL default '0',
  PRIMARY KEY  (id)

);
DROP TABLE Contact;
CREATE TABLE Contact (
  id integer NOT NULL default nextval('Contact_id_seq'),
  waiting varchar(1) check (waiting in ('N','Y')) default 'N',
  member varchar(1) check (member in ('N','Y')) default 'N',
  volunteer varchar(1) check (volunteer in ('N','Y')) default 'N',
  donor varchar(1) check (donor in ('N','Y')) default 'N',
  buyer varchar(1) check (buyer in ('N','Y')) default 'N',
  contactType varchar(1) check (contactType in ('O','P')) NOT NULL default 'P',
  firstname varchar(25) ,
  middlename varchar(25) ,
  lastname varchar(50) ,
  organization varchar(50) ,
  address varchar(50) ,
  address2 varchar(50) ,
  city varchar(30) NOT NULL default 'Portland',
  state varchar(2) default 'OR',
  zip varchar(10) ,
  phone varchar(20) ,
  fax varchar(20) ,
  email varchar(50) ,
  emailOK varchar(1),
  mailOK varchar(1),
  phoneOK varchar(1),
  faxOK varchar(1),
  notes text,
  modified timestamp default now(),
  created timestamp default now(),
  sortName varchar(25) ,
  preferEmail varchar(1),
  comp4kids varchar(1),
  recycler varchar(1),
  grantor varchar(1),
  build varchar(1),
  adopter varchar(1),
  PRIMARY KEY  (id)

);
DROP TABLE ContactList;
CREATE TABLE ContactList (
  id integer NOT NULL default nextval('ContactList_id_seq'),
  contactId integer NOT NULL default '0',
  listName varchar(20) ,
  putOnList date default NULL,
  modified timestamp default now(),
  created timestamp default now(),
  removedFromList date default NULL,
  active varchar(1) check (active in ('Y','N')) default 'Y',
  remarks text,
  PRIMARY KEY  (id)

);
DROP TABLE ControllerCard;
CREATE TABLE ControllerCard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  numSerial integer NOT NULL default '0',
  numParallel integer NOT NULL default '0',
  numIDE integer NOT NULL default '0',
  floppy varchar(1) check (floppy in ('N','Y')) NOT NULL default 'Y',
  PRIMARY KEY  (id)

);
DROP TABLE DaysOff;
CREATE TABLE DaysOff (
  id integer NOT NULL default nextval('DaysOff_id_seq'),
  contactId integer NOT NULL default '0',
  dayOff date default NULL,
  vacation varchar(1) check (vacation in ('N','Y')) default 'N',
  offsiteWork varchar(1) check (offsiteWork in ('N','Y')) default 'N',
  notes text,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE Donation;
CREATE TABLE Donation (
  id integer NOT NULL default nextval('Donation_id_seq'),
  contactId integer NOT NULL default '0',
  contactType varchar(1) check (contactType in ('O','P')) NOT NULL default 'P',
  firstname varchar(25) ,
  middlename varchar(25) ,
  lastname varchar(50) ,
  organization varchar(50) ,
  address varchar(50) ,
  address2 varchar(50) ,
  city varchar(30) NOT NULL default 'Portland',
  state varchar(2) default 'OR',
  zip varchar(10) ,
  phone varchar(20) ,
  email varchar(50) ,
  emailOK varchar(1) check (emailOK in ('N','Y')) NOT NULL default 'Y',
  mailOK varchar(1) check (mailOK in ('N','Y')) NOT NULL default 'Y',
  phoneOK varchar(1) check (phoneOK in ('N','Y')) NOT NULL default 'Y',
  cashDonation NUMERIC(8,2) NOT NULL default '0.00',
  modified timestamp default now(),
  created timestamp default now(),
  sortName varchar(25) default NULL,
  mbrPayment varchar(1) check (mbrPayment in ('N','Y')) NOT NULL default 'N',
  comp4kids varchar(1) check (comp4kids in ('N','Y')) NOT NULL default 'N',
  monitorFee NUMERIC(8,2) default '0.00',
  PRIMARY KEY  (id)

);
DROP TABLE DonationLine;
CREATE TABLE DonationLine (
  id integer NOT NULL default nextval('DonationLine_id_seq'),
  donationId integer NOT NULL default '0',
  description text,
  quantity integer NOT NULL default '1',
  PRIMARY KEY  (id)

);
DROP TABLE Drive;
CREATE TABLE Drive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  PRIMARY KEY  (id)

);
DROP TABLE FloppyDrive;
CREATE TABLE FloppyDrive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  diskSize varchar(10) default NULL,
  capacity varchar(10) default NULL,
  cylinders integer default '0',
  heads integer default '0',
  sectors integer default '0',
  PRIMARY KEY  (id)

);
DROP TABLE Gizmo;
CREATE TABLE Gizmo (
  id integer NOT NULL default nextval('Gizmo_id_seq'),
  classTree varchar(100) ,
  modified timestamp default now(),
  created timestamp default now(),
  oldStatus varchar(15) ,
  newStatus varchar(15) NOT NULL default 'Received',
  obsolete varchar(1) check (obsolete in ('N','Y','M')) NOT NULL default 'N',
  working varchar(1) check (working in ('N','Y','M')) NOT NULL default 'M',
  architecture varchar(10) NOT NULL default 'PC',
  manufacturer varchar(50) ,
  modelNumber varchar(50) ,
  location varchar(10) NOT NULL default 'Free Geek',
  notes text,
  testData varchar(1) check (testData in ('N','Y')) default 'N',
  value NUMERIC(5,1) NOT NULL default '0.0',
  inventoried timestamp default now(),
  builderId integer NOT NULL default '0',
  inspectorId integer NOT NULL default '0',
  linuxfund varchar(1) check (linuxfund in ('N','Y','M')) NOT NULL default 'N',
  cashValue NUMERIC(8,2) NOT NULL default '0.00',
  needsExpert varchar(1) check (needsExpert in ('N','Y')) default 'N',
  gizmoType varchar(10) default 'Other',
  adopterId integer NOT NULL default '0',
  PRIMARY KEY  (id)



);
DROP TABLE GizmoClones;
CREATE TABLE GizmoClones (
  id integer NOT NULL default nextval('GizmoClones_id_seq'),
  parentId integer NOT NULL default '0',
  childId integer NOT NULL default '0',
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)


);
DROP TABLE GizmoStatusChanges;
CREATE TABLE GizmoStatusChanges (
  id integer NOT NULL default '0',
  oldStatus varchar(15) ,
  newStatus varchar(15) ,
  created timestamp default now(),
  change_id integer NOT NULL default nextval('GizmoStatusChanges_change_id_seq'),
  PRIMARY KEY  (change_id)



);
DROP TABLE Holidays;
CREATE TABLE Holidays (
  id integer NOT NULL default nextval('Holidays_id_seq'),
  name varchar(50) ,
  holiday date default NULL,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE IDEHardDrive;
CREATE TABLE IDEHardDrive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  cylinders integer NOT NULL default '0',
  heads integer NOT NULL default '0',
  sectors integer NOT NULL default '0',
  ata varchar(10) ,
  sizeMb integer NOT NULL default '0',
  PRIMARY KEY  (id)

);
DROP TABLE Income;
CREATE TABLE Income (
  id integer NOT NULL default nextval('Income_id_seq'),
  incomeType varchar(10) ,
  description varchar(50) ,
  received date default NULL,
  amount NUMERIC(8,2) NOT NULL default '0.00',
  modified timestamp default now(),
  created timestamp default now(),
  contactId integer NOT NULL default '0',
  PRIMARY KEY  (id)
);
DROP TABLE IssueNotes;
CREATE TABLE IssueNotes (
  id integer NOT NULL default '0',
  issueId integer NOT NULL default '0',
  techname varchar(25) ,
  notes text,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE Issues;
CREATE TABLE Issues (
  id integer NOT NULL default '0',
  contactId integer NOT NULL default '0',
  gizmoId integer NOT NULL default '0',
  issuename varchar(100) ,
  issuestatus varchar(10) ,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE Jobs;
CREATE TABLE Jobs (
  id integer NOT NULL default nextval('Jobs_id_seq'),
  job varchar(50) ,
  scheduleName varchar(15) NOT NULL default 'Main',
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE Keyboard;
CREATE TABLE Keyboard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  kbType varchar(10) default NULL,
  numKeys varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Laptop;
CREATE TABLE Laptop (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  ram integer default NULL,
  hardDriveSizeGb integer default NULL,
  chipClass varchar(15) ,
  chipSpeed integer NOT NULL default '0',
  PRIMARY KEY  (id)

);
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
DROP TABLE Materials;
CREATE TABLE Materials (
  id integer NOT NULL default nextval('Materials_id_seq'),
  modified timestamp default now(),
  created timestamp default now(),
  materialName varchar(25) ,
  rateBase varchar(1) check (rateBase in ('W','P')) default 'W',
  defaultUnit varchar(20) ,
  PRIMARY KEY  (id)
);
DROP TABLE Member;
CREATE TABLE Member (
  id integer NOT NULL default '0',
  memberType varchar(1) check (memberType in ('V','M','N')) default 'M',
  howFoundOut text,
  interestComputer varchar(1) check (interestComputer in ('N','Y')) NOT NULL default 'N',
  interestClasses varchar(1) check (interestClasses in ('N','Y')) NOT NULL default 'N',
  interestAccess varchar(1) check (interestAccess in ('N','Y')) NOT NULL default 'N',
  skillHardware varchar(1) check (skillHardware in ('N','Y')) NOT NULL default 'N',
  textHardware text,
  skillNetwork varchar(1) check (skillNetwork in ('N','Y')) NOT NULL default 'N',
  textNetwork text,
  skillLinux varchar(1) check (skillLinux in ('N','Y')) NOT NULL default 'N',
  textLinux text,
  skillSoftware varchar(1) check (skillSoftware in ('N','Y')) NOT NULL default 'N',
  textSoftware text,
  skillTeaching varchar(1) check (skillTeaching in ('N','Y')) NOT NULL default 'N',
  textTeaching text,
  skillOtherComputer varchar(1) check (skillOtherComputer in ('N','Y')) NOT NULL default 'N',
  textOtherComputer text,
  skillAdmin varchar(1) check (skillAdmin in ('N','Y')) NOT NULL default 'N',
  textAdmin text,
  skillConstruction varchar(1) check (skillConstruction in ('N','Y')) NOT NULL default 'N',
  textConstruction text,
  skillVolunteerCoord varchar(1) check (skillVolunteerCoord in ('N','Y')) NOT NULL default 'N',
  textVolunteerCoord text,
  skillOther varchar(1) check (skillOther in ('N','Y')) NOT NULL default 'N',
  textOther text,
  notes text,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE MemberHour;
CREATE TABLE MemberHour (
  id integer NOT NULL default nextval('MemberHour_id_seq'),
  memberId integer NOT NULL default '0',
  workDate date default NULL,
  inTime time default NULL,
  outTime time default NULL,
  jobType varchar(15) ,
  jobDescription text,
  hours NUMERIC(5,2) NOT NULL default '0.00',
  modified timestamp default now(),
  created timestamp default now(),
  payType varchar(1) check (payType in ('V','W','H','O')) NOT NULL default 'V',
  PRIMARY KEY  (id)

);
DROP TABLE MiscCard;
CREATE TABLE MiscCard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  miscNotes text,
  PRIMARY KEY  (id)

);
DROP TABLE MiscComponent;
CREATE TABLE MiscComponent (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  miscNotes text,
  PRIMARY KEY  (id)

);
DROP TABLE MiscDrive;
CREATE TABLE MiscDrive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  miscNotes text,
  PRIMARY KEY  (id)

);
DROP TABLE MiscGizmo;
CREATE TABLE MiscGizmo (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  PRIMARY KEY  (id)

);
DROP TABLE Modem;
CREATE TABLE Modem (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  speed varchar(15) ,
  PRIMARY KEY  (id)

);
DROP TABLE ModemCard;
CREATE TABLE ModemCard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  speed varchar(15) ,
  PRIMARY KEY  (id)

);
DROP TABLE Monitor;
CREATE TABLE Monitor (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  size varchar(10) ,
  resolution varchar(10) ,
  PRIMARY KEY  (id)

);
DROP TABLE NetworkCard;
CREATE TABLE NetworkCard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  speed varchar(10) ,
  rj45 varchar(1) check (rj45 in ('N','Y')) NOT NULL default 'N',
  aux varchar(1) check (aux in ('N','Y')) NOT NULL default 'N',
  bnc varchar(1) check (bnc in ('N','Y')) NOT NULL default 'N',
  thicknet varchar(1) check (thicknet in ('N','Y')) NOT NULL default 'N',
  module varchar(50) ,
  io varchar(10) ,
  irq varchar(2) ,
  PRIMARY KEY  (id)

);
DROP TABLE NetworkingDevice;
CREATE TABLE NetworkingDevice (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  speed varchar(10) ,
  rj45 varchar(1) check (rj45 in ('N','Y')) NOT NULL default 'N',
  aux varchar(1) check (aux in ('N','Y')) NOT NULL default 'N',
  bnc varchar(1) check (bnc in ('N','Y')) NOT NULL default 'N',
  thicknet varchar(1) check (thicknet in ('N','Y')) NOT NULL default 'N',
  PRIMARY KEY  (id)

);
DROP TABLE Organization;
CREATE TABLE Organization (
  id integer NOT NULL default '0',
  contactId integer NOT NULL default '0',
  missionStatement text,
  modified timestamp default now(),
  created timestamp default now(),
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
DROP TABLE PickupLines;
CREATE TABLE PickupLines (
  id integer NOT NULL default nextval('PickupLines_id_seq'),
  modified timestamp default now(),
  created timestamp default now(),
  pickupId integer NOT NULL default '0',
  materialId integer NOT NULL default '0',
  pickupUnitType varchar(20) ,
  processedUnitType varchar(20) ,
  pickupUnitCount integer NOT NULL default '1',
  processedUnitCount integer NOT NULL default '1',
  pickupWeight NUMERIC(10,2) NOT NULL default '0.00',
  processedWeight NUMERIC(10,2) NOT NULL default '0.00',
  amountCharged NUMERIC(10,2) NOT NULL default '0.00',
  rate NUMERIC(10,4) NOT NULL default '0.0000',
  PRIMARY KEY  (id)
);
DROP TABLE Pickups;
CREATE TABLE Pickups (
  id integer NOT NULL default nextval('Pickups_id_seq'),
  modified timestamp default now(),
  created timestamp default now(),
  vendorId integer NOT NULL default '0',
  pickupDate date NOT NULL ,
  receiptNumber varchar(20) ,
  settlementNumber varchar(20) ,
  PRIMARY KEY  (id)
);
DROP TABLE PointingDevice;
CREATE TABLE PointingDevice (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  connector varchar(10) default NULL,
  pointerType varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE PowerSupply;
CREATE TABLE PowerSupply (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  watts integer NOT NULL default '0',
  connection varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Printer;
CREATE TABLE Printer (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  speedppm integer NOT NULL default '0',
  printerType varchar(10) default NULL,
  interface varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Processor;
CREATE TABLE Processor (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  chipClass varchar(15) ,
  interface varchar(10) default NULL,
  speed integer NOT NULL default '0',
  PRIMARY KEY  (id)

);
DROP TABLE SCSICard;
CREATE TABLE SCSICard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  internalInterface varchar(15) default NULL,
  externalInterface varchar(15) default NULL,
  parms text,
  PRIMARY KEY  (id)

);
DROP TABLE SCSIHardDrive;
CREATE TABLE SCSIHardDrive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  sizeMb integer NOT NULL default '0',
  scsiVersion varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Sales;
CREATE TABLE Sales (
  id integer NOT NULL default nextval('Sales_id_seq'),
  contactId integer NOT NULL default '0',
  contactType varchar(1) check (contactType in ('O','P')) NOT NULL default 'P',
  firstname varchar(25) ,
  middlename varchar(25) ,
  lastname varchar(50) ,
  organization varchar(50) ,
  address varchar(50) ,
  address2 varchar(50) ,
  city varchar(30) NOT NULL default 'Portland',
  state varchar(2) default 'OR',
  zip varchar(10) ,
  phone varchar(20) ,
  email varchar(50) ,
  emailOK varchar(1) check (emailOK in ('N','Y')) NOT NULL default 'Y',
  mailOK varchar(1) check (mailOK in ('N','Y')) NOT NULL default 'Y',
  phoneOK varchar(1) check (phoneOK in ('N','Y')) NOT NULL default 'Y',
  modified timestamp default now(),
  created timestamp default now(),
  subtotal NUMERIC(8,2) NOT NULL default '0.00',
  discount NUMERIC(8,2) NOT NULL default '0.00',
  total NUMERIC(8,2) NOT NULL default '0.00',
  sortname varchar(25) ,
  PRIMARY KEY  (id)

);
DROP TABLE SalesLine;
CREATE TABLE SalesLine (
  id integer NOT NULL default nextval('SalesLine_id_seq'),
  salesId integer NOT NULL default '0',
  gizmoId integer NOT NULL default '0',
  description text,
  cashValue NUMERIC(8,2) NOT NULL default '0.00',
  subtotal NUMERIC(8,2) NOT NULL default '0.00',
  discount NUMERIC(8,2) NOT NULL default '0.00',
  total NUMERIC(8,2) NOT NULL default '0.00',
  merchType varchar(15) ,
  PRIMARY KEY  (id)


);
DROP TABLE Scanner;
CREATE TABLE Scanner (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  interface varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE ScratchPad;
CREATE TABLE ScratchPad (
  id integer NOT NULL default nextval('ScratchPad_id_seq'),
  pageId integer NOT NULL default '0',
  modified timestamp default now(),
  created timestamp default now(),
  contactId integer NOT NULL default '0',
  name varchar(25) ,
  note text,
  urgent varchar(1) check (urgent in ('N','Y')) default 'N',
  visible varchar(1) check (visible in ('N','Y')) default 'Y',
  PRIMARY KEY  (id)
);
DROP TABLE SoundCard;
CREATE TABLE SoundCard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  soundType varchar(15) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Speaker;
CREATE TABLE Speaker (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  powered varchar(1) check (powered in ('N','Y')) NOT NULL default 'N',
  subwoofer varchar(1) check (subwoofer in ('N','Y')) NOT NULL default 'N',
  PRIMARY KEY  (id)

);
DROP TABLE System;
CREATE TABLE System (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
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
  ram integer default NULL,
  videoRAM integer default NULL,
  sizeMb integer default NULL,
  scsi varchar(1) check (scsi in ('N','Y')) default 'N',
  chipClass varchar(15) ,
  speed integer NOT NULL default '0',
  PRIMARY KEY  (id)

);
DROP TABLE SystemBoard;
CREATE TABLE SystemBoard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  pciSlots integer NOT NULL default '0',
  vesaSlots integer NOT NULL default '0',
  isaSlots integer NOT NULL default '0',
  eisaSlots integer NOT NULL default '0',
  agpSlot varchar(1) check (agpSlot in ('N','Y')) default 'N',
  ram30pin integer NOT NULL default '0',
  ram72pin integer NOT NULL default '0',
  ram168pin integer NOT NULL default '0',
  dimmSpeed varchar(10) ,
  proc386 integer NOT NULL default '0',
  proc486 integer NOT NULL default '0',
  proc586 integer NOT NULL default '0',
  procMMX integer NOT NULL default '0',
  procPRO integer NOT NULL default '0',
  procSocket7 integer NOT NULL default '0',
  procSlot1 integer NOT NULL default '0',
  PRIMARY KEY  (id)

);
DROP TABLE SystemCase;
CREATE TABLE SystemCase (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  caseType varchar(10) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE TapeDrive;
CREATE TABLE TapeDrive (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  interface varchar(15) default NULL,
  PRIMARY KEY  (id)

);
DROP TABLE Unit2Material;
CREATE TABLE Unit2Material (
  id integer NOT NULL default nextval('Unit2Material_id_seq'),
  modified timestamp default now(),
  created timestamp default now(),
  materialId integer NOT NULL default '0',
  unitType varchar(20) ,
  PRIMARY KEY  (id)
);
DROP TABLE Users;
CREATE TABLE Users (
  id integer NOT NULL default nextval('Users_id_seq'),
  username varchar(50) NOT NULL UNIQUE,
  password varchar(50) ,
  usergroup varchar(50) ,
  PRIMARY KEY  (id)
--    UNIQUE (username)
);
DROP TABLE VideoCard;
CREATE TABLE VideoCard (
  id integer NOT NULL default '0',
  classTree varchar(100) ,
  videoMemory varchar(10) default NULL,
  resolutions text,
  PRIMARY KEY  (id)

);
DROP TABLE WeeklyShifts;
CREATE TABLE WeeklyShifts (
  id integer NOT NULL default nextval('WeeklyShifts_id_seq'),
  scheduleName varchar(15) NOT NULL default 'Main',
  contactId integer NOT NULL default '0',
  jobId integer NOT NULL default '0',
  weekday integer NOT NULL default '0',
  inTime time default NULL,
  outTime time default NULL,
  meeting varchar(1) check (meeting in ('N','Y')) default 'N',
  effective date NOT NULL default '2004-01-01',
  ineffective date NOT NULL default '3004-01-01',
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE WorkMonths;
CREATE TABLE WorkMonths (
  id integer NOT NULL default nextval('WorkMonths_id_seq'),
  contactId integer NOT NULL default '0',
  work_year integer NOT NULL default '2004',
  work_month integer NOT NULL default '1',
  day_01 NUMERIC(5,2) NOT NULL default '0.00',
  day_02 NUMERIC(5,2) NOT NULL default '0.00',
  day_03 NUMERIC(5,2) NOT NULL default '0.00',
  day_04 NUMERIC(5,2) NOT NULL default '0.00',
  day_05 NUMERIC(5,2) NOT NULL default '0.00',
  day_06 NUMERIC(5,2) NOT NULL default '0.00',
  day_07 NUMERIC(5,2) NOT NULL default '0.00',
  day_08 NUMERIC(5,2) NOT NULL default '0.00',
  day_09 NUMERIC(5,2) NOT NULL default '0.00',
  day_10 NUMERIC(5,2) NOT NULL default '0.00',
  day_11 NUMERIC(5,2) NOT NULL default '0.00',
  day_12 NUMERIC(5,2) NOT NULL default '0.00',
  day_13 NUMERIC(5,2) NOT NULL default '0.00',
  day_14 NUMERIC(5,2) NOT NULL default '0.00',
  day_15 NUMERIC(5,2) NOT NULL default '0.00',
  day_16 NUMERIC(5,2) NOT NULL default '0.00',
  day_17 NUMERIC(5,2) NOT NULL default '0.00',
  day_18 NUMERIC(5,2) NOT NULL default '0.00',
  day_19 NUMERIC(5,2) NOT NULL default '0.00',
  day_20 NUMERIC(5,2) NOT NULL default '0.00',
  day_21 NUMERIC(5,2) NOT NULL default '0.00',
  day_22 NUMERIC(5,2) NOT NULL default '0.00',
  day_23 NUMERIC(5,2) NOT NULL default '0.00',
  day_24 NUMERIC(5,2) NOT NULL default '0.00',
  day_25 NUMERIC(5,2) NOT NULL default '0.00',
  day_26 NUMERIC(5,2) NOT NULL default '0.00',
  day_27 NUMERIC(5,2) NOT NULL default '0.00',
  day_28 NUMERIC(5,2) NOT NULL default '0.00',
  day_29 NUMERIC(5,2) NOT NULL default '0.00',
  day_30 NUMERIC(5,2) NOT NULL default '0.00',
  day_31 NUMERIC(5,2) NOT NULL default '0.00',
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
--    UNIQUE (contactId,work_year,work_month)
);
DROP TABLE Workers;
CREATE TABLE Workers (
  id integer NOT NULL default '0',
  sunday NUMERIC(5,2) NOT NULL default '0.00',
  monday NUMERIC(5,2) NOT NULL default '0.00',
  tuesday NUMERIC(5,2) NOT NULL default '8.00',
  wednesday NUMERIC(5,2) NOT NULL default '8.00',
  thursday NUMERIC(5,2) NOT NULL default '8.00',
  friday NUMERIC(5,2) NOT NULL default '8.00',
  saturday NUMERIC(5,2) NOT NULL default '8.00',
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE WorkersQualifyForJobs;
CREATE TABLE WorkersQualifyForJobs (
  id integer NOT NULL default nextval('WorkersQualifyForJobs_id_seq'),
  contactId integer NOT NULL default '0',
  jobId integer NOT NULL default '0',
  inJobDescription varchar(1) check (inJobDescription in ('N','Y')) default 'N',
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE all_emails;
CREATE TABLE all_emails (
  contactId integer default nextval('all_emails_id_seq'),
  listname varchar(50) NOT NULL default 'FGDB',
  email varchar(50) ,
  firstname varchar(25) ,
  middlename varchar(25) ,
  lastname varchar(50) ,
  created timestamp
);
DROP TABLE allowedStatuses;
CREATE TABLE allowedStatuses (
  id integer NOT NULL default nextval('allowedStatuses_id_seq'),
  oldStatus varchar(15) ,
  newStatus varchar(15) ,
  PRIMARY KEY  (id)


);
DROP TABLE anonDict;
CREATE TABLE anonDict (
  id integer NOT NULL default nextval('anonDict_id_seq'),
  dictType integer default NULL,
  value varchar(50) default NULL,
  PRIMARY KEY  (id)
);
DROP TABLE answers;
CREATE TABLE answers (
  id integer NOT NULL default nextval('answers_id_seq'),
  fk_sess_id integer default NULL,
  qnum integer default NULL,
  ansr varchar(255) default NULL,
  fk_questions_id integer default NULL,
  PRIMARY KEY  (id)
);
DROP TABLE classTree;
CREATE TABLE classTree (
  id integer NOT NULL default nextval('classTree_id_seq'),
  classTree varchar(100) ,
  tableName varchar(50) ,
  level integer default NULL,
  instantiable varchar(1) check (instantiable in ('N','Y')) NOT NULL default 'Y',
  intakeCode varchar(10) default NULL,
  intakeAdd integer default NULL,
  description varchar(50) ,
  PRIMARY KEY  (id)


);
DROP TABLE codedInfo;
CREATE TABLE codedInfo (
  id integer NOT NULL default nextval('codedInfo_id_seq'),
  codeType varchar(100) ,
  codeLength integer default '10',
  code varchar(25) ,
  description text,
  modified timestamp default now(),
  created timestamp default now(),
  PRIMARY KEY  (id)
);
DROP TABLE defaultValues;
CREATE TABLE defaultValues (
  id integer NOT NULL default nextval('defaultValues_id_seq'),
  classTree varchar(100) ,
  fieldName varchar(50) ,
  defaultValue varchar(50) default NULL,
  PRIMARY KEY  (id)


);
DROP TABLE fieldMap;
CREATE TABLE fieldMap (
  id integer NOT NULL default nextval('fieldMap_id_seq'),
  tableName varchar(50) ,
  fieldName varchar(50) ,
  displayOrder integer NOT NULL default '0',
  inputWidget varchar(50) default NULL,
  inputWidgetParameters varchar(100) default NULL,
  outputWidget varchar(50) default NULL,
  outputWidgetParameters varchar(100) default NULL,
  editable varchar(1) check (editable in ('N','Y')) default 'Y',
  helpLink varchar(1) check (helpLink in ('N','Y')) default 'N',
  description varchar(100) ,
  PRIMARY KEY  (id)



);
DROP TABLE helpScreen;
CREATE TABLE helpScreen (
  id integer NOT NULL default nextval('helpScreen_id_seq'),
  tableName varchar(50) ,
  fieldName varchar(50) ,
  displayOrder integer NOT NULL default '0',
  helpText text,
  imageURL text,
  PRIMARY KEY  (id)



);
DROP TABLE options;
CREATE TABLE options (
  id integer NOT NULL default nextval('options_id_seq'),
  fk_qid integer default NULL,
  qopts text,
  PRIMARY KEY  (id)
);
DROP TABLE questions;
CREATE TABLE questions (
  id integer NOT NULL default nextval('questions_id_seq'),
  qtext text,
  qhint text,
  qnum integer default NULL,
  qname varchar(16) default NULL,
  qtype varchar(4) default NULL,
  qargx varchar(50) default NULL,
  qatxt varchar(50) default NULL,
  qsrc varchar(4) default NULL,
  qgrp varchar(25) default NULL,
  active integer default NULL,
  PRIMARY KEY  (id)
);
DROP TABLE relations;
CREATE TABLE relations (
  id integer NOT NULL default nextval('relations_id_seq'),
  parentTable varchar(50) ,
  parentField varchar(50) ,
  parentMultiplicity varchar(10) ,
  childTable varchar(50) ,
  childField varchar(50) ,
  childMultiplicity varchar(10) ,
  PRIMARY KEY  (id)
);
DROP TABLE sessions;
CREATE TABLE sessions (
  id integer NOT NULL default nextval('sessions_id_seq'),
  sysid varchar(10) default NULL,
  status integer default NULL,
  nextq integer default NULL,
  boxtype varchar(20) default NULL,
  mtime varchar(50) default NULL,
  isold varchar(1) check (isold in ('Y','N')) default 'N',
  PRIMARY KEY  (id)
);
