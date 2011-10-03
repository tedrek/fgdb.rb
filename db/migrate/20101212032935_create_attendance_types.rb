class CreateAttendanceTypes < ActiveRecord::Migration
  def self.up
    create_table :attendance_types do |t|
      t.string :name
      t.boolean :cancelled

      t.timestamps
    end

    add_column "assignments", "attendance_type_id", :integer
    add_foreign_key "assignments", ["attendance_type_id"], "attendance_types", ["id"], :on_delete => :restrict

    AttendanceType.new(:name => "arrived").save!
    AttendanceType.new(:name => "tardy").save!
    AttendanceType.new(:name => "no call no show", :cancelled => true).save!
    AttendanceType.new(:name => "wrong time", :cancelled => true).save!
    AttendanceType.new(:name => "cancelled", :cancelled => true).save!
  end

  def self.down
    drop_table :attendance_types
  end
end
