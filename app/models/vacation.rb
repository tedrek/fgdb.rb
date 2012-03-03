class Vacation < ActiveRecord::Base
  belongs_to :worker

  validate :worker_is_not_virtual

  def worker_is_not_virtual
    errors.add("worker_id", "is not a real worker") if self.worker.virtual
    errors.add_on_blank("effective_date")
    errors.add_on_blank("ineffective_date")
  end

  def name
    effective_date.strftime("%a, %b %d, %Y") + ' to ' + ineffective_date.strftime("%a, %b %d, %Y")
  end

end
