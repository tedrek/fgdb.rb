class PopulateSortName < ActiveRecord::Migration
  def self.up
    puts 'installing plpgsql'
    begin
      Contact.connection.execute('CREATE LANGUAGE plpgsql')
    rescue
      # just ignore it, must already be loaded
    end

    Contact.connection.execute("ALTER TABLE contacts ALTER sort_name TYPE character varying(100);")

    puts "creating populate_contact_sortname() function"
    Contact.connection.execute("
      CREATE OR REPLACE FUNCTION populate_contact_sortname() RETURNS trigger as $populate_contact_sortname$
        BEGIN
          IF NEW.surname != OLD.surname
             or NEW.first_name != OLD.first_name
             or NEW.middle_name != OLD.middle_name
          THEN
            NEW.sort_name = LOWER(NEW.surname || '::' || NEW.first_name || '::' || NEW.middle_name);
          END IF;
          RETURN NEW;
        END;
      $populate_contact_sortname$ LANGUAGE plpgsql;
      ");

    puts "creating populate_contact_sortname() function"
    Contact.connection.execute('
      CREATE TRIGGER populate_contact_sortname
        BEFORE INSERT OR UPDATE
        ON contacts
        FOR EACH ROW
        EXECUTE PROCEDURE populate_contact_sortname();
      ');

    puts "populating the Contact.sort_name"
    Contact.connection.execute("UPDATE contacts SET sort_name=LOWER(surname||'::'||first_name||'::'||middle_name)")

    add_index "contacts", ["sort_name"]
  end

  def self.down
  end
end
