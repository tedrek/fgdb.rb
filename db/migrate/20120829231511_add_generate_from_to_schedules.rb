class AddGenerateFromToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :generate_from, :boolean, :default => false, :null => false
    main = Schedule.find_by_name("main")
    if main
      main.generate_from = true
      main.save
    end
  end

  def self.down
  end
end
