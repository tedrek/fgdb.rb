class Job < ActiveRecord::Base
  has_many :standard_shifts
  has_many :work_shifts
  belongs_to :program
  belongs_to :wc_category
  belongs_to :income_stream
  named_scope :workable, :conditions => {:virtual => false}
  named_scope :logable, :conditions => ["reason_cannot_log_hours IS NULL OR reason_cannot_log_hours LIKE ''"]

  named_scope :effective_on, lambda { |date|
    { :conditions => ['(effective_on IS NULL OR effective_on <= ?) AND (ineffective_on IS NULL OR ineffective_on > ?)', date, date] }
  }

  named_scope :effective_in_range, lambda { |*args|
    start, fin = Worker._effective_in_range(args)
    {:conditions => ["(((effective_on <= ? OR effective_on IS NULL) AND (ineffective_on > ? OR ineffective_on IS NULL)) OR (effective_on > ? AND ineffective_on <= ?) OR ((ineffective_on is NULL or ineffective_on > ?) AND (effective_on IS NULL or effective_on <= ?)))", start, start, start, fin, fin, fin]}
  }

  def to_s
    name
  end
end

