class PricingValue < ActiveRecord::Base
  has_and_belongs_to_many :system_pricings
  belongs_to :pricing_component
  define_amount_methods_on :value

  def matches?(value)
    match_against = (self.matcher && self.matcher.length > 0) ? self.matcher : self.name
    SystemPricing.does_match?(self.matcher, value)
  end
end
