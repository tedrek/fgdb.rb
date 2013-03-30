class PricingExpression < ActiveRecord::Base
  has_and_belongs_to_many :pricing_components
  belongs_to :pricing_type
  define_amount_methods_on :multiplier

  def amount(pricing_values)
    v = [self.multiplier_cents]
    pricing_values.each do |value|
      if self.pricing_components.include?(value.pricing_component)
        v << (value.pricing_component.multiplier_cents * value.value_cents/10000.0)
      end
    end
    return 0.0 if v.length == 1
    return v.inject(1.0){|t,x| t = t * x }
  end

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
