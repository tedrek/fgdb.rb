CREATE TRIGGER Borrow_created_trigger BEFORE INSERT ON Borrow FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Borrow_modified_trigger BEFORE UPDATE ON Borrow FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Contact_created_trigger BEFORE INSERT ON Contact FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Contact_modified_trigger BEFORE UPDATE ON Contact FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER ContactList_created_trigger BEFORE INSERT ON ContactList FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER ContactList_modified_trigger BEFORE UPDATE ON ContactList FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER DaysOff_created_trigger BEFORE INSERT ON DaysOff FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER DaysOff_modified_trigger BEFORE UPDATE ON DaysOff FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Donation_created_trigger BEFORE INSERT ON Donation FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Donation_modified_trigger BEFORE UPDATE ON Donation FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Gizmo_created_trigger BEFORE INSERT ON Gizmo FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Gizmo_modified_trigger BEFORE UPDATE ON Gizmo FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER GizmoClones_created_trigger BEFORE INSERT ON GizmoClones FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER GizmoClones_modified_trigger BEFORE UPDATE ON GizmoClones FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

 -- :TODO: should have created, not modified, but created requires a modified field...
 -- CREATE TRIGGER GizmoStatusChanges_created_trigger BEFORE INSERT ON GizmoStatusChanges FOR EACH ROW EXECUTE PROCEDURE created_trigger();
 -- CREATE TRIGGER GizmoStatusChanges_modified_trigger BEFORE UPDATE ON GizmoStatusChanges FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Holidays_created_trigger BEFORE INSERT ON Holidays FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Holidays_modified_trigger BEFORE UPDATE ON Holidays FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Income_created_trigger BEFORE INSERT ON Income FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Income_modified_trigger BEFORE UPDATE ON Income FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER IssueNotes_created_trigger BEFORE INSERT ON IssueNotes FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER IssueNotes_modified_trigger BEFORE UPDATE ON IssueNotes FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Issues_created_trigger BEFORE INSERT ON Issues FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Issues_modified_trigger BEFORE UPDATE ON Issues FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Jobs_created_trigger BEFORE INSERT ON Jobs FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Jobs_modified_trigger BEFORE UPDATE ON Jobs FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Materials_created_trigger BEFORE INSERT ON Materials FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Materials_modified_trigger BEFORE UPDATE ON Materials FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Member_created_trigger BEFORE INSERT ON Member FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Member_modified_trigger BEFORE UPDATE ON Member FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER MemberHour_created_trigger BEFORE INSERT ON MemberHour FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER MemberHour_modified_trigger BEFORE UPDATE ON MemberHour FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Organization_created_trigger BEFORE INSERT ON Organization FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Organization_modified_trigger BEFORE UPDATE ON Organization FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Pages_created_trigger BEFORE INSERT ON Pages FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Pages_modified_trigger BEFORE UPDATE ON Pages FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER PickupLines_created_trigger BEFORE INSERT ON PickupLines FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER PickupLines_modified_trigger BEFORE UPDATE ON PickupLines FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Pickups_created_trigger BEFORE INSERT ON Pickups FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Pickups_modified_trigger BEFORE UPDATE ON Pickups FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Sales_created_trigger BEFORE INSERT ON Sales FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Sales_modified_trigger BEFORE UPDATE ON Sales FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER ScratchPad_created_trigger BEFORE INSERT ON ScratchPad FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER ScratchPad_modified_trigger BEFORE UPDATE ON ScratchPad FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Shifts_created_trigger BEFORE INSERT ON Shifts FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Shifts_modified_trigger BEFORE UPDATE ON Shifts FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER StandardShifts_created_trigger BEFORE INSERT ON StandardShifts FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER StandardShifts_modified_trigger BEFORE UPDATE ON StandardShifts FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Unit2Material_created_trigger BEFORE INSERT ON Unit2Material FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Unit2Material_modified_trigger BEFORE UPDATE ON Unit2Material FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER WeeklyShifts_created_trigger BEFORE INSERT ON WeeklyShifts FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER WeeklyShifts_modified_trigger BEFORE UPDATE ON WeeklyShifts FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER WorkMonths_created_trigger BEFORE INSERT ON WorkMonths FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER WorkMonths_modified_trigger BEFORE UPDATE ON WorkMonths FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER Workers_created_trigger BEFORE INSERT ON Workers FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER Workers_modified_trigger BEFORE UPDATE ON Workers FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER WorkersQualifyForJobs_created_trigger BEFORE INSERT ON WorkersQualifyForJobs FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER WorkersQualifyForJobs_modified_trigger BEFORE UPDATE ON WorkersQualifyForJobs FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

CREATE TRIGGER codedInfo_created_trigger BEFORE INSERT ON codedInfo FOR EACH ROW EXECUTE PROCEDURE created_trigger();
CREATE TRIGGER codedInfo_modified_trigger BEFORE UPDATE ON codedInfo FOR EACH ROW EXECUTE PROCEDURE modified_trigger();

