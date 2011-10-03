class ClassCreditBoolean < ActiveRecord::Migration
  def self.up
    add_column :volunteer_default_shifts, :class_credit, :boolean
    add_column :volunteer_shifts, :class_credit, :boolean
  end

  def self.down
  end
end
