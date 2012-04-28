class RenameSupportToTechSupport < ActiveRecord::Migration
  def self.up
    vtt = VolunteerTaskType.find_by_name('support')
    vtt.description = 'tech support'
    vtt.save
  end

  def self.down
  end
end
