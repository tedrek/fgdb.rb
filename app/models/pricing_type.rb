class PricingType < ActiveRecord::Base
  has_and_belongs_to_many :types
  belongs_to :gizmo_type
  has_many :pricing_expressions
  define_amount_methods_on :base_value
  define_amount_methods_on :multiplier
  define_amount_methods_on :round_by
  belongs_to :replaced_by, :foreign_key => "replaced_by_id", :class_name => "PricingType"
  validates_presence_of :name
  validates_presence_of :matcher, :if => Proc.new{|t| !t.pull_from.blank?}, :message => "is required if there is a pulled value"
  validates_presence_of :pull_from, :if => Proc.new{|t| !t.matcher.blank?}, :message => "is required if there is a value to match"

  named_scope :active, :conditions => ['ineffective_on IS NULL']
  named_scope :automatic, :conditions => ["(pull_from IS NOT NULL AND pull_from <> '') OR id IN (SELECT pricing_type_id FROM pricing_types_types)"]

  HUMAN_NAMES = {:matcher => "Value to match", :pull_from => "Pulled value"}

  def values_to_lookup
    pricing_components.select{|x| !(x.lookup_type.to_s.length == 0 or x.pull_from.to_s.length == 0)}
  end

  def to_equation_text
    multiplier + ' * (' + ((self.base_value_cents == 0 ? [] : [self.base_value]) + pricing_expressions.map{|x| x.to_equation_text}).join(' + ') + ')'
  end

  def pricing_components
    self.pricing_expressions.map(&:pricing_components).flatten.uniq
  end

  def matching_conds
    count = 0
    count += 1 if self.pull_from and self.pull_from != ""
    count += 1 if self.types.length > 0
    return count
  end

  def replaced?
    !! self.replaced_by
  end

  def finally_replaced_by
    self.replaced_by ? self.replaced_by.finally_replaced_by : self
  end

  def self.human_attribute_name(attr)
    HUMAN_NAMES[attr.to_sym] || super
  end

  def matches?(pricing_hash)
    matches = true
    checked = false
    if matches && self.types.length > 0
      matches = self.types.map(&:name).include?(pricing_hash[:build_type])
      checked = true
    end
    if matches && self.pull_from && self.pull_from.length > 0
      matches = SystemPricing.does_match?(self.matcher, pricing_hash[self.pull_from.to_sym])
      checked = true
    end
    return matches && checked
  end
end
