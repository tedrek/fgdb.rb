class BeMoreLikeFgdb < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE contacts ADD COLUMN user_id bigint"
    execute "ALTER TABLE contacts DROP COLUMN created_by"
    execute "ALTER TABLE contacts DROP COLUMN updated_by"
    execute "ALTER TABLE contacts ADD COLUMN created_by bigint"
    execute "ALTER TABLE contacts ADD COLUMN updated_by bigint"
  end

  def self.down
    execture "ALTER TABLE contacts DROP COLUMN user_id"
  end
end
