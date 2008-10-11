class ForeignKeysOnCreatedAndUpdatedBy < ActiveRecord::Migration
  def self.up
    for i in [:actions, :contacts, :donations, :sales, :spec_sheets, :systems, :types, :users, :volunteer_tasks]
      add_foreign_key i.to_s, ["created_by"], "users", ["id"], :on_delete => :restrict
      add_foreign_key i.to_s, ["updated_by"], "users", ["id"], :on_delete => :restrict
    end
  end

  def self.down
    for i in [:actions, :contacts, :donations, :sales, :spec_sheets, :systems, :types, :users, :volunteer_tasks]
      remove_foreign_key i.to_s, "#{i.to_s}_updated_by_fkey"
      remove_foreign_key i.to_s, "#{i.to_s}_created_by_fkey"
    end
  end
end
