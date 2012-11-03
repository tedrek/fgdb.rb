class PricingExpression < ActiveRecord::Base
  has_and_belongs_to_many :pricing_components
  belongs_to :pricing_types
end
