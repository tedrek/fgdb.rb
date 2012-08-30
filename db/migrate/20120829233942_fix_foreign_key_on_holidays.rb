class FixForeignKeyOnHolidays < ActiveRecord::Migration
  def self.up
    remove_foreign_key "holidays", "holidays_schedules"
    add_foreign_key "holidays", ["schedule_id"], "schedules", ["id"], :on_delete => :cascade, :name => "holidays_schedules"

  end

  def self.down
  end
end
