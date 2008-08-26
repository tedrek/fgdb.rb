class FixSortName < ActiveRecord::Migration
  def self.up
    puts 'installing plpgsql'
    begin
      Contact.connection.execute('CREATE LANGUAGE plpgsql')
    rescue
      # just ignore it, must already be loaded
    end

    begin
      remove_index "contacts", ["sort_name"]
    rescue
      # it wasn't there before, and the old migration will have been ran on some databases
    end

    Contact.connection.execute("ALTER TABLE contacts ALTER sort_name TYPE character varying(100);")

    begin
      Contact.connection.execute("DROP TRIGGER populate_contact_sortname ON contacts;")
    rescue
    end

    begin
      Contact.connection.execute("DROP FUNCTION populate_contact_sortname();")
    rescue
    end

    begin
    Contact.connection.execute("DROP TRIGGER contact_addr_insert_trigger ON contacts;")
    rescue
    end

Contact.connection.execute("CREATE OR REPLACE FUNCTION get_sort_name(boolean, character varying, character varying, character varying, character varying) RETURNS character varying
    AS '
DECLARE
    IS_ORG ALIAS FOR $1 ;
    FIRST_NAME ALIAS FOR $2 ;
    MIDDLE_NAME ALIAS FOR $3 ;
    LAST_NAME ALIAS FOR $4 ;
    ORG_NAME ALIAS FOR $5 ;

BEGIN
    IF IS_ORG = ''f'' THEN
       RETURN
         SUBSTR( TRIM( LOWER( 
           COALESCE(TRIM(LAST_NAME), '''') || 
           COALESCE('' '' || TRIM(FIRST_NAME), '''') || 
           COALESCE('' '' || TRIM(MIDDLE_NAME), '''')
         )), 0, 25 );
    ELSE
       IF TRIM(ORG_NAME) ILIKE ''THE %'' THEN 
           -- maybe take into account A and AN as first words
           -- like this as well
           RETURN LOWER(SUBSTR(TRIM(ORG_NAME), 5, 25));
       ELSE
           RETURN SUBSTR(LOWER(TRIM(ORG_NAME)), 0, 25 );
       END IF;
    END IF;
    RETURN '''';
END;
'
    LANGUAGE plpgsql;")


#Contact.connection.execute("UPDATE contacts SET sort_name = get_sort_name(is_organization, first_name, middle_name, surname, organization);")

Contact.connection.execute("CREATE OR REPLACE FUNCTION contact_trigger() RETURNS \"trigger\"
    AS '
BEGIN
    NEW.sort_name := get_sort_name(NEW.is_organization, NEW.first_name, NEW.middle_name, NEW.surname, NEW.organization);
    RETURN NEW;
END;
'
    LANGUAGE plpgsql;")


Contact.connection.execute("CREATE TRIGGER contact_addr_insert_trigger
    BEFORE INSERT OR UPDATE ON contacts
    FOR EACH ROW
    EXECUTE PROCEDURE contact_trigger();")

    add_index "contacts", ["sort_name"]
  end

  def self.down
  end
end
