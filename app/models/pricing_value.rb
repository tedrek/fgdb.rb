class PricingValue < ActiveRecord::Base
  has_and_belongs_to_many :system_pricings
  belongs_to :pricing_component
  define_amount_methods_on :value
  belongs_to :replaced_by, :foreign_key => "replaced_by_id", :class_name => "PricingType"
  named_scope :active, :conditions => ['ineffective_on IS NULL']
  validates_presence_of :name
  validates_presence_of :value_cents

  def finally_replaced_by
    self.replaced_by ? self.replaced_by.finally_replaced_by : self
  end

  def matches?(value)
    if self.pricing_component && self.pricing_component.numerical && self.minimum && self.maximum
      i = value.to_i
      return i >= self.minimum && i <= self.maximum
    else
      match_against = (self.matcher && self.matcher.length > 0) ? self.matcher : self.name
      return SystemPricing.does_match?(match_against, value)
    end
  end
end
