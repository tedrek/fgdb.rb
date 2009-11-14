class WorkersWorkerType < ActiveRecord::Base
  named_scope :effective_on, lambda { |date|
    { :conditions => ['(effective_on IS NULL OR effective_on <= ?) AND (ineffective_on IS NULL OR ineffective_on > ?)', date, date] }
  }
  belongs_to :worker
  belongs_to :worker_type
end
