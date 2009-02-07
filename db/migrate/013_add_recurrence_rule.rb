class AddRecurrenceRule < ActiveRecord::Migration
  def self.up
    create_table "rr_sets", :force => true do |t|
      t.column "name",             :string
      t.column "effective_date",   :date
      t.column "ineffective_date", :date
      t.column "match_mode",       :integer, :default => 0
    end
    execute 'COMMENT ON TABLE rr_sets IS \'Recurrence rule sets are groups of rules that combine to define on what days scheduled events happen.\' '

    create_table "rr_items", :force => true do |t|
      t.column "rr_set_id",          :integer
      t.column "repeats_every",      :integer, :default => 1
      t.column "repeats_on",         :integer, :default => 0
      t.column "weekday_0",          :boolean, :default => true
      t.column "weekday_1",          :boolean, :default => true
      t.column "weekday_2",          :boolean, :default => true
      t.column "weekday_3",          :boolean, :default => true
      t.column "weekday_4",          :boolean, :default => true
      t.column "weekday_5",          :boolean, :default => true
      t.column "weekday_6",          :boolean, :default => true
      t.column "day_of_month_flip",  :boolean, :default => false
      t.column "min_day_of_month",   :integer
      t.column "max_day_of_month",   :integer
      t.column "week_of_month_flip", :boolean, :default => false
      t.column "week_of_month_1",    :boolean, :default => true
      t.column "week_of_month_2",    :boolean, :default => true
      t.column "week_of_month_3",    :boolean, :default => true
      t.column "week_of_month_4",    :boolean, :default => true
      t.column "week_of_month_5",    :boolean, :default => true
      t.column "month_of_year_01",   :boolean, :default => true
      t.column "month_of_year_02",   :boolean, :default => true
      t.column "month_of_year_03",   :boolean, :default => true
      t.column "month_of_year_04",   :boolean, :default => true
      t.column "month_of_year_05",   :boolean, :default => true
      t.column "month_of_year_06",   :boolean, :default => true
      t.column "month_of_year_07",   :boolean, :default => true
      t.column "month_of_year_08",   :boolean, :default => true
      t.column "month_of_year_09",   :boolean, :default => true
      t.column "month_of_year_11",   :boolean, :default => true
      t.column "month_of_year_10",   :boolean, :default => true
      t.column "month_of_year_12",   :boolean, :default => true
    end
    execute 'ALTER TABLE rr_items ADD CONSTRAINT rr_items_rr_sets FOREIGN KEY ( rr_set_id ) REFERENCES rr_sets( id ) ON DELETE CASCADE'
    execute 'COMMENT ON TABLE rr_items IS \'Recurrence rule items are expressions that define on what days scheduled events happen.\' '
  end

  def self.down
    drop_table "rr_sets"
    drop_table "rr_items"
  end
end
