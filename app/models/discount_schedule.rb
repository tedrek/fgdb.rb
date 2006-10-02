require 'ajax_scaffold'

class DiscountSchedule < ActiveRecord::Base
  validates_uniqueness_of :short_name

end
