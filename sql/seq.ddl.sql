create sequence Borrow_id_seq;
select setval('Borrow_id_seq', (select max(id) from Borrow));

create sequence Contact_id_seq;
select setval('Contact_id_seq', (select max(id) from Contact));

create sequence ContactList_id_seq;
select setval('ContactList_id_seq', (select max(id) from ContactList));

create sequence DaysOff_id_seq;
select setval('DaysOff_id_seq', (select max(id) from DaysOff));

create sequence Donation_id_seq;
select setval('Donation_id_seq', (select max(id) from Donation));

create sequence DonationLine_id_seq;
select setval('DonationLine_id_seq', (select max(id) from DonationLine));

create sequence Gizmo_id_seq;
select setval('Gizmo_id_seq', (select max(id) from Gizmo));

create sequence GizmoClones_id_seq;
select setval('GizmoClones_id_seq', (select max(id) from GizmoClones));

create sequence GizmoStatusChanges_change_id_seq;
select setval('GizmoStatusChanges_change_id_seq', (select max(change_id) from GizmoStatusChanges));

create sequence Holidays_id_seq;
select setval('Holidays_id_seq', (select max(id) from Holidays));

create sequence Income_id_seq;
select setval('Income_id_seq', (select max(id) from Income));

create sequence Jobs_id_seq;
select setval('Jobs_id_seq', (select max(id) from Jobs));

create sequence Links_id_seq;
select setval('Links_id_seq', (select max(id) from Links));

create sequence Materials_id_seq;
select setval('Materials_id_seq', (select max(id) from Materials));

create sequence MemberHour_id_seq;
select setval('MemberHour_id_seq', (select max(id) from MemberHour));

create sequence PageLinks_id_seq;
select setval('PageLinks_id_seq', (select max(id) from PageLinks));

create sequence Pages_id_seq;
select setval('Pages_id_seq', (select max(id) from Pages));

create sequence PickupLines_id_seq;
select setval('PickupLines_id_seq', (select max(id) from PickupLines));

create sequence Pickups_id_seq;
select setval('Pickups_id_seq', (select max(id) from Pickups));

create sequence Sales_id_seq;
select setval('Sales_id_seq', (select max(id) from Sales));

create sequence SalesLine_id_seq;
select setval('SalesLine_id_seq', (select max(id) from SalesLine));

create sequence ScratchPad_id_seq;
select setval('ScratchPad_id_seq', (select max(id) from ScratchPad));

create sequence Shifts_id_seq;
select setval('Shifts_id_seq', (select max(id) from Shifts));

create sequence StandardShifts_id_seq;
select setval('StandardShifts_id_seq', (select max(id) from StandardShifts));

create sequence Unit2Material_id_seq;
select setval('Unit2Material_id_seq', (select max(id) from Unit2Material));

create sequence Users_id_seq;
select setval('Users_id_seq', (select max(id) from Users));

create sequence WeeklyShifts_id_seq;
select setval('WeeklyShifts_id_seq', (select max(id) from WeeklyShifts));

create sequence WorkMonths_id_seq;
select setval('WorkMonths_id_seq', (select max(id) from WorkMonths));

create sequence WorkersQualifyForJobs_id_seq;
select setval('WorkersQualifyForJobs_id_seq', (select max(id) from WorkersQualifyForJobs));

create sequence allowedStatuses_id_seq;
select setval('allowedStatuses_id_seq', (select max(id) from allowedStatuses));

create sequence anonDict_id_seq;
select setval('anonDict_id_seq', (select max(id) from anonDict));

create sequence answers_id_seq;
select setval('answers_id_seq', (select max(id) from answers));

create sequence classTree_id_seq;
select setval('classTree_id_seq', (select max(id) from classTree));

create sequence codedInfo_id_seq;
select setval('codedInfo_id_seq', (select max(id) from codedInfo));

create sequence defaultValues_id_seq;
select setval('defaultValues_id_seq', (select max(id) from defaultValues));

create sequence fieldMap_id_seq;
select setval('fieldMap_id_seq', (select max(id) from fieldMap));

create sequence helpScreen_id_seq;
select setval('helpScreen_id_seq', (select max(id) from helpScreen));

create sequence options_id_seq;
select setval('options_id_seq', (select max(id) from options));

create sequence questions_id_seq;
select setval('questions_id_seq', (select max(id) from questions));

create sequence relations_id_seq;
select setval('relations_id_seq', (select max(id) from relations));

create sequence sessions_id_seq;
select setval('sessions_id_seq', (select max(id) from sessions));

