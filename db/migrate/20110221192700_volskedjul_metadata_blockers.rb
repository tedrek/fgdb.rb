class VolskedjulMetadataBlockers < ActiveRecord::Migration
  def self.up
    add_column :volunteer_default_events, :notes, :text
    add_column :volunteer_events, :notes, :text

    add_column :volunteer_default_shifts, :description, :string
    add_column :volunteer_shifts, :description, :string

    add_column :assignments, :notes, :text

    add_column :volunteer_default_shifts, :program_id, :integer
    add_column :volunteer_shifts, :program_id, :integer

    add_foreign_key "volunteer_default_shifts", ["program_id"], "programs", ["id"], :on_delete => :set_null
    add_foreign_key "volunteer_shifts", ["program_id"], "programs", ["id"], :on_delete => :set_null
  end

  def self.down
  end
end
