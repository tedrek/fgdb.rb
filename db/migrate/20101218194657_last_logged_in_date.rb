class LastLoggedInDate < ActiveRecord::Migration
  def self.up
    add_column(:users, :last_logged_in, :date)
  end

  def self.down
  end
end
