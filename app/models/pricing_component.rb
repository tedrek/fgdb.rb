class PricingComponent < ActiveRecord::Base
  has_many :pricing_values
  has_and_belongs_to_many :pricing_types

  def required?
    ! multiple
  end
end
