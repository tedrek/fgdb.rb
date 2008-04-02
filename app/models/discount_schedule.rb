class DiscountSchedule < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  has_many :discount_schedules_gizmo_types
  has_many :gizmo_types, :through => :discount_schedules_gizmo_types

  def multiplier_for(type)
    data = discount_schedules_gizmo_types.detect {|bridge| bridge.gizmo_type_id == type.id}
    data ? data.multiplier : nil
  end

  class << self
    #:MC: these are all lame
    def volunteer
      find(:first, :conditions => ['name = ?', 'volunteer'])
    end

    def same_day_donor
      find(:first, :conditions => ['name = ?', 'same-day donor'])
    end

    def no_discount
      find(:first, :conditions => ['name = ?', 'no discount'])
    end
  end # class << self
end
