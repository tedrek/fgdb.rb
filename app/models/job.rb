class Job < ActiveRecord::Base
  has_many :standard_shifts
  has_many :work_shifts
  belongs_to :coverage_type
  belongs_to :program
  belongs_to :wc_category
  belongs_to :income_stream
  named_scope :workable, :conditions => {:virtual => false}

  named_scope :effective_on, lambda { |date|
    { :conditions => ['(effective_on IS NULL OR effective_on <= ?) AND (ineffective_on IS NULL OR ineffective_on > ?)', date, date] }
  }

  def to_s
    description
  end

  def description
    read_attribute(:name)
  end

  def full_description
    read_attribute(:description)
  end

  def full_description=(a)
    self.description = a
  end
end

