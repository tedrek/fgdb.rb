class CopyTaskTypeCountsFromReceiving < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      vtt = VolunteerTaskType.find_by_name('sorting')
      vtt2 = VolunteerTaskType.find_by_name('receiving')

      ContactVolunteerTaskTypeCount.find_all_by_volunteer_task_type_id(vtt2.id).each do |old|
        old.contact.update_syseval_count(vtt.id)
      end

      vtt2.ineffective_on = Date.today
      vtt2.save!
    end
  end

  def self.down
  end
end
