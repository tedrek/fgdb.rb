class CreateContactsMailings < ActiveRecord::Migration
  def self.up
    create_table :contacts_mailings do |t|
      t.integer    :contact_id,    :null => false
      t.integer    :mailing_id,    :null => false
      t.boolean    :bounced,       :null => false, :default => false
      t.datetime   :response_date
      t.integer    :response_amount_cents
      t.text       :response_note
    end

    add_foreign_key :contacts_mailings, ["contact_id"], :contacts, ["id"]
    add_foreign_key :contacts_mailings, ["mailing_id"], :mailings, ["id"]

    add_index :contacts_mailings, ["mailing_id", "contact_id"], :name => "contacts_mailings_ak", :unique =>true
    add_index :contacts_mailings, ["contact_id"]
  end

  def self.down
    drop_table :contacts_mailings
  end
end
