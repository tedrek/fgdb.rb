DROP FUNCTION gizmo_status_changed();
DROP FUNCTION gizmo_status_insert();
DROP TRIGGER Gizmo_status_change_trigger ON Gizmo;
DROP TRIGGER Gizmo_status_insert_trigger ON Gizmo;

CREATE FUNCTION gizmo_status_changed() returns OPAQUE AS '
  BEGIN
    IF NEW.newstatus <> OLD.newstatus THEN
      INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (OLD.id, OLD.newstatus, NEW.newstatus);
      -- this is redundant oldstatus is in the history table, so
      -- it does not really need to be in gizmo as well
      NEW.oldstatus := OLD.newstatus;
    END IF;
    RETURN NEW;
  END;
'language 'plpgsql';

CREATE FUNCTION gizmo_status_insert() returns OPAQUE AS '
  BEGIN
    INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (NEW.id, ''none'', NEW.newstatus);
    -- this is redundant oldstatus is in the history table, so
    -- it does not really need to be in gizmo as well
    NEW.oldstatus := ''none'';
    RETURN NEW;
  END;
'language 'plpgsql';



CREATE TRIGGER Gizmo_status_change_trigger BEFORE UPDATE ON Gizmo FOR EACH ROW EXECUTE PROCEDURE gizmo_status_changed();
CREATE TRIGGER Gizmo_status_insert_trigger BEFORE INSERT ON Gizmo FOR EACH ROW EXECUTE PROCEDURE gizmo_status_insert();

