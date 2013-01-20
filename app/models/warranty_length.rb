class WarrantyLength < ActiveRecord::Base
  validates_presence_of :system_type
  validates_presence_of :length
  validates_presence_of :box_source

  named_scope :effective_on, lambda { |date|
    { :conditions => ['(effective_on IS NULL OR effective_on <= ?) AND (ineffective_on IS NULL OR ineffective_on > ?)', date, date] }
  }

  def self.find_warranty_for(date_out, system_type, box_source, os_type = nil)
    WarrantyLength.effective_on(date_out).select{|x| x.system_type == system_type && x.box_source == box_source && (x.os_type.nil? || os_type == x.os_type)}.first
  end

  def eval_length
    eval(length)
  end

  def from_date(d = nil)
    d ||= Date.today
    d + eval_length
  end
end
