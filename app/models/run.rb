class Run < ActiveRecord::Base
  belongs_to :drive
  has_many   :checks

  validates :drive, presence: true
  validates :device_name, presence: true
  validates :start_time, presence: true
  validates :result, presence: true

  after_initialize :set_defaults

  private
  def set_defaults
    result ||= 'In progress'
  end
end
