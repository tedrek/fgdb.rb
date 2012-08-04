class PricingValue < ActiveRecord::Base
  has_and_belongs_to_many :system_pricings
  belongs_to :pricing_component
  define_amount_methods_on :value
end
