class AddWeekOfMonthBooleansForStaffsched < ActiveRecord::Migration
  def self.up
    for i in [:week_1_of_month, :week_2_of_month, :week_3_of_month, :week_4_of_month, :week_5_of_month]
      add_column :shifts, i, :boolean, :default => true, :null => false
    end
  end

  def self.down
  end
end
