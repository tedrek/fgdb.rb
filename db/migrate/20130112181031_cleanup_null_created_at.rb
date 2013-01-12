class CleanupNullCreatedAt < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE disbursements SET created_at = disbursed_at WHERE created_at IS NULL;")
  end

  def self.down
  end
end
