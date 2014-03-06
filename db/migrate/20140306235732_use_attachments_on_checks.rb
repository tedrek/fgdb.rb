class UseAttachmentsOnChecks < ActiveRecord::Migration
  def self.up
    change_table :checks do |t|
      t.remove :stdout_log, :stderr_log
    end
  end

  def self.down
    change_table :checks do |t|
      t.string :stdout_log
      t.string :stderr_log
    end
  end
end
