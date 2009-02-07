class EffectiveDatesOnWorkers < ActiveRecord::Migration
  def self.up
    add_column "workers", "effective_date", :date, :default => '1901-12-22'
    add_column "workers", "ineffective_date", :date, :default => '2100-12-31'
    execute 'UPDATE workers SET effective_date = \'1901-12-22\''
    execute 'UPDATE workers SET ineffective_date = \'2100-12-31\''
  end

  def self.down
    drop_column "workers", "effective_date"
    drop_column "workers", "ineffective_date"
  end
end
