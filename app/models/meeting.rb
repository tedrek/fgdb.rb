class Meeting < ActiveRecord::Base
  has_many :standard_shifts
  has_many :work_shifts
  has_and_belongs_to_many :workers
  belongs_to :weekday
  belongs_to :schedule
  belongs_to :frequency_type
end
