class PricingComponent < ActiveRecord::Base
  has_many :pricing_values, :order => 'value_cents DESC'
  has_and_belongs_to_many :pricing_types

  def matched_pricing_value(pricing_hash)
    return nil unless self.pull_from and self.pull_from.length > 0
    self.pricing_values.each do |x|
      if x.matches?(pricing_hash[self.pull_from.to_sym])
        return x
      end
    end
    return nil
  end

  def required?
    ! multiple
  end
end
