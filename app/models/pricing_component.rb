class PricingComponent < ActiveRecord::Base
  has_many :pricing_values, :order => 'value_cents DESC', :conditions => 'pricing_values.ineffective_on IS NULL'
  has_and_belongs_to_many :pricing_expressions
  validates_presence_of :name
  define_amount_methods_on :multiplier

#  has_and_belongs_to_many :pricing_types, :through => :pricing_expressions, :conditions => 'pricing_types.ineffective_on IS NULL'
  def pricing_types
    self.pricing_expressions.map(&:pricing_type).select{|x| x.ineffective_on.nil?}
  end

  def to_equation_text
    added = self.name.downcase.gsub(" ", "_").gsub("/", "_")
    return multiplier_cents != 100 ? "(#{self.multiplier} * #{added})" : added
  end

  def to_equation(pv)
    all_mine = pv.select{|x| x.pricing_component == self }
    return "0" if all_mine.length == 0
    added = all_mine.length == 1 ? all_mine.first.value : '(' + all_mine.map{|x| x.value}.join(" + ") + ')'
    return multiplier_cents != 100 ? "(#{self.multiplier} * #{added})" : added
  end

  def display_name
    n = self.name
    n += " (#{self.pricing_types.map(&:name).join(", ")})" if self.pricing_types.length > 0
    return n
  end

  def printme_pull(pricing_hash)
    pricing_hash[self.pull_from.to_sym]
  end

  def find_value(pricing_hash)
    return nil unless self.pull_from and self.pull_from.length > 0
    v = printme_pull(pricing_hash)
    return v unless self.lookup_column and self.lookup_column.length > 0
    return v unless self.lookup_table and self.lookup_table.length > 0
    v = PricingData.lookup(self.lookup_table, v, self.lookup_column)
    return v
  end

  def matched_pricing_value(pricing_hash)
    return [] unless self.pull_from and self.pull_from.length > 0
    list = []
    expect = find_value(pricing_hash)
    self.pricing_values.each do |x|
      if x.matches?(expect)
        if self.required?
          return [x]
        else
          list << x
        end
      end
    end
    return list
  end

  def required?
    ! multiple
  end
end
