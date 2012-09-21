class SetDescriptionWhenNull < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE gizmo_events SET description = '' WHERE description IS NULL;")
  end

  def self.down
  end
end
