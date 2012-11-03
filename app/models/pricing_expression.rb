class PricingExpression < ActiveRecord::Base
  has_and_belongs_to_many :pricing_components
end
