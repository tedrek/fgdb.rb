class ShiftFootnote < ActiveRecord::Base
  belongs_to :weekday
  belongs_to :schedule

  def date
    weekday_id
  end
end
