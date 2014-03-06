class Run < ActiveRecord::Base
  belongs_to :drive
  has_many   :checks

  validates :drive, presence: true
  validates :device_name, presence: true
  validates :start_time, presence: true
end
