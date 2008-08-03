class MakeDiscountScheduleRequired < ActiveRecord::Migration
  def self.up
    Sale.connection.execute("DELETE FROM sales WHERE discount_schedule_id IS NULL; ALTER TABLE sales ALTER discount_schedule_id SET NOT NULL;")
  end

  def self.down
  end
end
