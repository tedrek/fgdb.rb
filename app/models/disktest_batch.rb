class DisktestBatch < ActiveRecord::Base
  belongs_to :contact
  has_many :disktest_batch_drives, :class_name => "DisktestBatchDrive"

  validates_presence_of :name
  validates_presence_of :date
  validates_presence_of :contact_id
  validates_existence_of :contact
end
