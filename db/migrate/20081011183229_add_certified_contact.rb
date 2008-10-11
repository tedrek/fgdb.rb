class AddCertifiedContact < ActiveRecord::Migration
  def self.up
    add_column 'contacts', :addr_certified, :boolean, :null => false, :default=>false
    Contact.connection.execute(%q[
CREATE OR REPLACE FUNCTION uncertify_address() RETURNS trigger AS '
BEGIN
  IF tg_op = ''UPDATE'' THEN
    IF ((NEW.address IS NULL != OLD.address IS NULL
         OR NEW.address != OLD.address)
         OR (NEW.extra_address IS NULL != OLD.extra_address IS NULL
             OR NEW.extra_address != OLD.extra_address)
         OR (NEW.city IS NULL != OLD.city IS NULL
             OR NEW.city != OLD.city)
         OR (NEW.state_or_province IS NULL != OLD.state_or_province IS NULL
             OR NEW.state_or_province != OLD.state_or_province)
         OR (NEW.postal_code IS NULL != OLD.postal_code IS NULL
             OR NEW.postal_code != OLD.postal_code)) THEN
      NEW.addr_certified = ''f'';
    END IF;
  END IF;
  RETURN NEW;
END
' LANGUAGE plpgsql;
    ])

    Contact.connection.execute(%q[
CREATE TRIGGER uncertify_address
BEFORE UPDATE ON contacts
FOR EACH ROW
EXECUTE PROCEDURE uncertify_address();
])
  end

  def self.down
    remove_column 'contacts', :addr_certified
    Contact.connection.execute("DROP TRIGGER uncertify_address ON contacts")
    Contact.connection.execute("DROP FUNCTION uncertify_address()")
  end
end
