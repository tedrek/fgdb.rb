class Check < ActiveRecord::Base
  belongs_to :run
  has_one    :drive, through: :run
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :run, presence: true
  validates :check_code, presence: true
  validates :check_name, presence: true
  validates :passed, inclusion: {in: [true, false] }
  validates :sequence_num, numericality: {only_integer: true}
  validates :status, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
