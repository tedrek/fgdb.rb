class RemoveNullDestroys < ActiveRecord::Migration
  def self.up
    Log.connection.execute("DELETE FROM logs WHERE thing_id IS NULL")
  end

  def self.down
    # it aint commin back now.
  end
end
