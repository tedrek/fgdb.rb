--going from gizmo towards the leaf:


select g.id as badcomponentid from gizmo g where not exists (select c.id from component c where c.id = g.id) and g.classtree like 'Gizmo.Component.%';


select c.id as badcardid from component c where not exists (select c.id from card a where a.id = c.id) and c.classtree like 'Gizmo.Component.Card.%';


select a.id as badmisccardid from card a where not exists (select c.id from misccard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.MiscCard';

select a.id as badmodemcardid from card a where not exists (select c.id from modemcard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.ModemCard';

select a.id as badnetworkcardid from card a where not exists (select c.id from networkcard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.NetworkCard';

select a.id as badscsicardid from card a where not exists (select c.id from scsicard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.SCSICard';

select a.id as badsoundcardid from card a where not exists (select c.id from soundcard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.SoundCard';

select a.id as badvideocardid from card a where not exists (select c.id from videocard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.VideoCard';

select a.id as badcontrollercardid from card a where not exists (select c.id from controllercard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Card.ControllerCard';



select a.id as baddriveid from component a where not exists (select c.id from drive c where a.id = c.id) and a.classtree like 'Gizmo.Component.Drive.%';

select a.id as badcddriveid from drive a where not exists (select d.id from cddrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.CDDrive';

select a.id as badfloppydriveid from drive a where not exists (select d.id from floppydrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.Floppy';

select a.id as badideharddriveid from drive a where not exists (select d.id from ideharddrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.IDEHardDrive';

select a.id as badmiscdriveid from drive a where not exists (select d.id from miscdrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.MiscDrive';

select a.id as badscsiharddriveid from drive a where not exists (select d.id from scsiharddrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.SCSIHardDrive';

select a.id as badtapedriveid from drive a where not exists (select d.id from tapedrive d where a.id = d.id) and a.classtree = 'Gizmo.Component.Drive.TapeDrive';




select a.id as badkeyboardid from component a where not exists (select c.id from keyboard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Keyboard';

select a.id  as badmisccomponentid from component a where not exists (select c.id from misccomponent c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.MiscComponent';

select a.id  as badmodemid from component a where not exists (select c.id from modem c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Modem';

select a.id  as badmonitorid from component a where not exists (select c.id from monitor c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Monitor';

select a.id  as badpointingdeviceid from component a where not exists (select c.id from pointingdevice c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.PointingDevice';

select a.id  as badpowersupplyid from component a where not exists (select c.id from powersupply c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.PowerSupply';

select a.id  as badprinterid from component a where not exists (select c.id from printer c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Printer';

select a.id  as badprocessorid from component a where not exists (select c.id from processor c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Processor';

select a.id  as badscannerid from component a where not exists (select c.id from scanner c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Scanner';

select a.id  as badspeakerid from component a where not exists (select c.id from speaker c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.Speaker';

select a.id  as badsystemboardid from component a where not exists (select c.id from systemboard c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.SystemBoard';

select a.id  as badsystemcaseid from component a where not exists (select c.id from systemcase c where a.id = c.id) and a.classtree = 'Gizmo.Component.Drive.SystemCase';







select m.id  as badmiscgizmoid from gizmo m where not exists (select g.id from miscgizmo g where m.id = g.id) and m.classtree = 'Gizmo.MiscGizmo';

select s.id  as badsystemid from gizmo s    where not exists (select g.id from system g where s.id = g.id) and s.classtree = 'Gizmo.System';

