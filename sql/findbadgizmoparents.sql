
select c.id as badcomponentid, c.classtree from component c where not exists (select g.id from gizmo g where c.id = g.id);


select a.id as badcardid, a.classtree from card a where not exists (select c.id from component c where a.id = c.id);


select a.id as badmisccardid, a.classtree from misccard a where not exists (select c.id from card c where a.id = c.id);

select a.id as badmodemcardid, a.classtree from modemcard a where not exists (select c.id from card c where a.id = c.id);

select a.id as badnetworkcardid, a.classtree from networkcard a where not exists (select c.id from card c where a.id = c.id);

select a.id as badscsicardid, a.classtree from scsicard a where not exists (select c.id from card c where a.id = c.id);

select a.id as badsoundcardid, a.classtree from soundcard a where not exists (select c.id from card c where a.id = c.id);

select a.id as badvideocardid, a.classtree from videocard a where not exists (select c.id from card c where a.id = c.id);

select a.id as badcontrollercardid, a.classtree from controllercard a where not exists (select c.id from card c where a.id = c.id);




select a.id as baddriveid, a.classtree from drive a where not exists (select c.id from component c where a.id = c.id);

select a.id as badcddriveid, a.classtree from cddrive a where not exists (select d.id from drive d where a.id = d.id);

select a.id as badfloppydriveid, a.classtree from floppydrive a where not exists (select d.id from drive d where a.id = d.id);

select a.id as badideharddriveid, a.classtree from ideharddrive a where not exists (select d.id from drive d where a.id = d.id);

select a.id as badmiscdriveid, a.classtree from miscdrive a where not exists (select d.id from drive d where a.id = d.id);

select a.id as badscsiharddriveid, a.classtree from scsiharddrive a where not exists (select d.id from drive d where a.id = d.id);

select a.id as badtapedriveid, a.classtree from tapedrive a where not exists (select d.id from drive d where a.id = d.id);




select a.id as badkeyboardid, a.classtree from keyboard a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badmisccomponentid, a.classtree from misccomponent a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badmodemid, a.classtree from modem a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badmonitorid, a.classtree from monitor a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badpointingdeviceid, a.classtree from pointingdevice a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badpowersupplyid, a.classtree from powersupply a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badprinterid, a.classtree from printer a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badprocessorid, a.classtree from processor a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badscannerid, a.classtree from scanner a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badspeakerid, classtree from speaker a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badsystemboardid, a.classtree from systemboard a where not exists (select c.id from component c where a.id = c.id);

select a.id  as badsystemcaseid, a.classtree from systemcase a where not exists (select c.id from component c where a.id = c.id);







select m.id  as badmiscgizmoid, m.classtree from miscgizmo m where not exists (select g.id from gizmo g where m.id = g.id);

select s.id  as badsystemid, s.classtree from system s    where not exists (select g.id from gizmo g where s.id = g.id);


