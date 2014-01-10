class AddAnonymousContact < ActiveRecord::Migration
  class Contact < ActiveRecord::Base
    def self.cashierable_possible
      false
    end
  end
  class User < ActiveRecord::Base; end

  def self.up
    c = Contact.new(first_name: 'Anonymous', surname: 'Anonymous')
    c.updated_by = 0
    c.created_by = 0
    c.id = 0
    c.save!

    User.find(0).update_attributes(contact_id: 0)
  end

  def self.down
    User.find(0).update_attributes(contact_id: nil)
    c = Contact.find_by_id(0)
    c.destroy unless c.nil?
  end
end
