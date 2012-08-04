class PricingType < ActiveRecord::Base
  belongs_to :type
  has_and_belongs_to_many :pricing_components
  define_amount_methods_on :base_value
  define_amount_methods_on :multiplier

  validates_presence_of :matcher, :if => Proc.new{|t| !!t.pull_from}
  validates_presence_of :pull_from, :if => Proc.new{|t| !!t.matcher}, :message => "is required if there is a "

  named_scope :automatic, :conditions => ["(pull_from IS NOT NULL AND pull_from <> '') OR type_id IS NOT NULL"]

  def matches?(pricing_values)
    matches = true
    checked = false
    if matches && self.type_id
      matches = pricing_values[:build_type] == self.type.name
      checked = true
    end
    if matches && self.pull_from
      matches = SystemPricing.does_match?(self.matcher, pricing_values[self.pull_from.to_sym])
      checked = true
    end
    return matches && checked
  end
end
