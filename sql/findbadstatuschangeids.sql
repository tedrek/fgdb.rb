create table tmpbadstatuschangeids as 
select id, count(*) as missingcount 
from gizmostatuschanges gsc1 
where not exists (select id from gizmostatuschanges gsc2 where gsc1.newstatus = gsc2.oldstatus and gsc1.id = gsc2.id) 
group by id 
having count(*) > 1;
