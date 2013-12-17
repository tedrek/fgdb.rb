class PunchEntry < ActiveRecord::Base
  belongs_to :contact
  belongs_to :volunteer_task

  scope :for_contact, ->(id) {
    where(contact_id: id).order('in_time DESC')
  }

  scope :open, where(out_time: nil)
end
