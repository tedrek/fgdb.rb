class SetCodingTicketOwner < ActiveRecord::Migration
  def self.up
    Default["coding_ticket_owner"] = "ryan52"
  end

  def self.down
  end
end
