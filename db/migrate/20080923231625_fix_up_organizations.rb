class FixUpOrganizations < ActiveRecord::Migration
  def self.up
    [
      "UPDATE contacts
       SET organization=null
       WHERE organization=''",
      "UPDATE contacts
      SET organization=null,
          is_organization=false
      WHERE is_organization=true
        AND (organization IS NULL
             OR organization = '')",
    ].each do |sql|
      Contact.connection.execute(sql)
    end
  end

  def self.down
  end
end
