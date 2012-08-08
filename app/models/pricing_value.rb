class PricingValue < ActiveRecord::Base
  has_and_belongs_to_many :system_pricings
  belongs_to :pricing_component
  define_amount_methods_on :value
  belongs_to :replaced_by, :foreign_key => "replaced_by_id", :class_name => "PricingType"
  named_scope :active, :conditions => ['ineffective_on IS NULL']

  def finally_replaced_by
    self.replaced_by ? self.replaced_by.finally_replaced_by : self
  end

  def matches?(value)
    match_against = (self.matcher && self.matcher.length > 0) ? self.matcher : self.name
    SystemPricing.does_match?(self.matcher, value)
  end
end
