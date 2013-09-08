class RemoveAttributesOnJoinTables < ActiveRecord::Migration
  class SkedMember < ActiveRecord::Base
  end

  def self.up
    remove_column :privileges_roles, :created_at
    remove_column :privileges_roles, :updated_at

    SkedMember.reset_column_information
    create_table :sked_members do |t|
      t.column :sked_id, :integer, :null => false
      t.column :roster_id, :integer, :null => false
      t.column :position, :integer, :null => false, :default => 1
    end

    rows = select_all('SELECT roster_id, sked_id, position FROM rosters_skeds;')
    rows.each do |r|
      p = r['position']
      p ||= 1
      SkedMember.create!(:roster_id => r['roster_id'],
                         :sked_id => r['sked_id'],
                         :position => p)
    end

    drop_table :rosters_skeds
  end

  def self.down
    raise "Unable to migrate down, migration irreversible"
  end
end
