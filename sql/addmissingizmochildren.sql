--insert missing records

insert into component (id, classtree) select a.id, a.classtree from gizmo a where not exists (select c.id from component c where a.id = c.id) and a.classtree like 'Gizmo.Component.%';


insert into card (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from card c where a.id = c.id) and a.classtree like 'Gizmo.Component.Card.%';


insert into misccard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from misccard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.MiscCard';

insert into modemcard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from modemcard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.ModemCard';

insert into networkcard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from networkcard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.NetworkCard';

insert into scsicard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from scsicard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.SCSICard';

insert into soundcard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from soundcard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.SoundCard';

insert into videocard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from videocard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.VideoCard';

insert into controllercard (id, classtree) select a.id, a.classtree from card a where not exists (select c.id from controllercard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.ControllerCard';



insert into drive (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from drive c where a.id = c.id) and a.classtree like 'Gizmo.Component.Drive.%';

insert into cddrive (id, classtree) select a.id, a.classtree from drive a where not exists (select d.id from cddrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.CDDrive';

insert into floppydrive (id, classtree) select a.id, a.classtree from drive a where not exists (select d.id from floppydrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.Floppy';

insert into ideharddrive (id, classtree) select a.id, a.classtree from drive a where not exists (select d.id from ideharddrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.IDEHardDrive';

insert into miscdrive (id, classtree) select a.id, a.classtree from drive a where not exists (select d.id from miscdrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.MiscDrive';

insert into scsiharddrive (id, classtree) select a.id, a.classtree from drive a where not exists (select d.id from scsiharddrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.SCSIHardDrive';

insert into tapedrive (id, classtree) select a.id, a.classtree from drive a where not exists (select d.id from tapedrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.TapeDrive';




insert into keyboard (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from keyboard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Keyboard';

insert into misccomponent (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from misccomponent c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.MiscComponent';

insert into modem (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from modem c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Modem';

insert into monitor (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from monitor c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Monitor';

insert into pointingdevice (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from pointingdevice c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.PointingDevice';

insert into powersupply (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from powersupply c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.PowerSupply';

insert into printer (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from printer c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Printer';

insert into processor (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from processor c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Processor';

insert into scanner (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from scanner c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Scanner';

insert into speaker (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from speaker c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Speaker';

insert into systemboard (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from systemboard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.SystemBoard';

insert into systemcase (id, classtree) select a.id, a.classtree from component a where not exists (select c.id from systemcase c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.SystemCase';







insert into miscgizmo (id, classtree) select a.id, a.classtree from gizmo a where not exists (select c.id from miscgizmo c where a.id = c.id) and a.classtree = 'Gizmo.MiscGizmo';

insert into system (id, classtree) select a.id, a.classtree from gizmo a where not exists (select c.id from system c where a.id = c.id) and a.classtree = 'Gizmo.System';

