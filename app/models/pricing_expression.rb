class PricingExpression < ActiveRecord::Base
  has_and_belongs_to_many :pricing_components
  belongs_to :pricing_types
  define_amount_methods_on :multiplier

  def to_equation_text
    a = self.multiplier_cents == 100 ? [] : [self.multiplier]
    a = a + self.pricing_components.map{|x| x.to_equation_text}
    return a.join(' * ')
  end

  def to_equation(pricing_values)
    a = self.multiplier_cents == 100 ? [] : [self.multiplier]
    a = a + self.pricing_components.map{|x| x.to_equation(pricing_values)}
    return a.join(' * ')
  end
end
