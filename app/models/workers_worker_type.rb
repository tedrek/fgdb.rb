class WorkersWorkerType < ActiveRecord::Base
  scope :effective_on, lambda { |date|
    where('(effective_on IS NULL
            OR effective_on <= ?)
           AND (ineffective_on IS NULL
                OR ineffective_on > ?)',
          date, date)
  }
  belongs_to :worker
  belongs_to :worker_type

  validates_existence_of :worker_type

  def smart_effective_on
    effective_on || Date.parse("1901-12-22")
  end

  def smart_ineffective_on
    ineffective_on || Date.parse("2100-12-31")
  end

  attr_accessor :killit, :my_super_worker
end

