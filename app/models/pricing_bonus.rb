class PricingBonus < ActiveRecord::Base
  define_amount_methods_on :amount
  belongs_to :system_pricing
end
