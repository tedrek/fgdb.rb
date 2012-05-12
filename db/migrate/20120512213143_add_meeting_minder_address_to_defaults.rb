class AddMeetingMinderAddressToDefaults < ActiveRecord::Migration
  def self.up
    Default['meeting_minder_address'] = "agendapoker@freegeek.org"
  end

  def self.down
  end
end
