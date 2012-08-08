class PricingComponent < ActiveRecord::Base
  has_many :pricing_values, :order => 'value_cents DESC', :conditions => 'pricing_values.ineffective_on IS NULL'
  has_and_belongs_to_many :pricing_types, :conditions => 'pricing_types.ineffective_on IS NULL'

  def matched_pricing_value(pricing_hash)
    return [] unless self.pull_from and self.pull_from.length > 0
    list = []
    self.pricing_values.each do |x|
      if x.matches?(pricing_hash[self.pull_from.to_sym])
        if self.required?
          return [x]
        else
          list << x
        end
      end
    end
    return list
  end

  def required?
    ! multiple
  end
end
