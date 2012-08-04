class PricingType < ActiveRecord::Base
  belongs_to :type
  has_and_belongs_to_many :pricing_components
  define_amount_methods_on :base_value
  define_amount_methods_on :multiplier

  def matches?(pricing_values)
    matches = true
    checked = false
    if matches and self.type_id
      matches = pricing_values[:build_type] == self.type.name
      checked = true
    end
    if matches and self.pull_value
      matches = pricing_type[self.pull_value.to_sym] == self.matcher
      checked = true
    end
    return matches and checked
  end
end
