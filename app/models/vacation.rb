class Vacation < ActiveRecord::Base
  acts_as_userstamp

  belongs_to :worker

  validate :worker_is_not_virtual

  scope :on_date, lambda { |date|
    where('? BETWEEN effective_date AND ineffective_date', date)
  }

  def worker_is_not_virtual
    errors.add("worker_id", "is not a real worker") if self.worker.virtual
    errors.add_on_blank("effective_date")
    errors.add_on_blank("ineffective_date")
  end

  def generate
    w = self.worker
    (self.effective_date..self.ineffective_date).each{|x|
      w.work_shifts_for_day(x).each{|x|
        x.on_vacation
      }
    }
  end

  def name
    effective_date.strftime("%a, %b %d, %Y") + ' to ' + ineffective_date.strftime("%a, %b %d, %Y")
  end

end
