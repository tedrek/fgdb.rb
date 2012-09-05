class AddReferenceFromToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :reference_from, :boolean, :default => false, :null => false
    main = Schedule.generate_from
    if main
      main.reference_from = true
      main.save
    end
  end

  def self.down
  end
end
