class ChangeToSimpleFinalWeek < ActiveRecord::Migration
  def self.up
    rename_column "rr_items", :week_of_month_flip, :week_of_month_final
    rename_column "rr_items", :day_of_month_flip, :day_of_month_final
  end

  def self.down
    rename_column "rr_items", :week_of_month_final, :week_of_month_flip
    rename_column "rr_items", :day_of_month_final, :day_of_month_flip
  end
end
