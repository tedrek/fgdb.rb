class Coveredness < ActiveRecord::Migration
  def self.up
    add_column :contacts, :fully_covered
    add_column :gizmo_types, :covered
    add_column :gizmo_events, :covered
    for i in [:coveredness_enabled, :fully_covered_contact_covered_gizmo, :fully_covered_contact_uncovered_gizmo, :unfully_covered_contact_covered_gizmo, :unfully_covered_contact_uncovered_gizmo]
      d = Default.new
      d.name = i.to_s
      d.value = 0
      d.save!
    end
  end

  def self.down
  end
end
