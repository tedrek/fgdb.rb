class SystemPricing < ActiveRecord::Base
  has_and_belongs_to_many :pricing_values
  belongs_to :system
  belongs_to :spec_sheet
  belongs_to :pricing_type
  define_amount_methods_on :calculated_price

  def self.does_match?(matcher, value)
    matcher.split(/\s+/).select{|x| !value.match(x)}.length == 0
  end

  before_save :set_calculated_price
  def set_calculated_price
    self.calculated_price_cents = calculate_price_cents
  end

  def cents_step_ceil(number, step)
    float = number / 100.0
    int = float.ceil
    mod = (int % step)
    if mod == 0
      return int
    else
      return int + (step - mod)
    end
  end

  def calculate_price_cents
    total = self.base_value_cents
    self.pricing_values.each do |value|
      total += value.value_cents
    end
    total = total * self.multiplier
    total = cents_step_ceil(total, self.round_by)
  end

  def system_id=(number)
    write_attribute(:system_id, number)
    if sys = System.find_by_id(number) and sys.spec_sheets.last
      self.spec_sheet = sys.spec_sheets.last
    end
    PricingType.automatic.each do |pt|
      if pt.matches?(self.pricing_values)
        self.pricing_type = pt
        break
      end
    end
  end

  attr_accessor :magic_bit

  def extra_valid?
    if self.spec_sheet.pricing_values[:product_processor_speed] and self.spec_sheet.pricing_values[:product_processor_speed].length > 0 and (self.spec_sheet.pricing_values[:running_processor_speed] != self.spec_sheet.pricing_values[:product_processor_speed])
      errors.add('spec_sheet_id', "detected a different running speed (#{self.spec_sheet.pricing_values[:running_processor_speed]}) than the processor product speed (#{self.spec_sheet.pricing_values[:product_processor_speed]})")
    end
    if self.spec_sheet.pricing_values[:total_ram] and self.spec_sheet.pricing_values[:total_ram].length > 0 and (self.spec_sheet.pricing_values[:total_ram] != self.spec_sheet.pricing_values[:individual_ram_total])
      errors.add('spec_sheet_id', "detected a different total amount of memory (#{self.spec_sheet.pricing_values[:total_ram]}) than the sum of the individual banks (#{self.spec_sheet.pricing_values[:individual_ram_total]})")
    end
  end

  def pricing_values
    @pricing_values ||= begin
                          h = {} # TODO: Remove all OH ordered hash processing, it is useless with pull list.
                          oh = self.spec_sheet.pricing_values
                          oh.each do |k, v|
                            if self.class.display_pulls.include?(k)
                              h[k] = v
                            end
                          end
                          h[:processor_speed] = (oh[:product_processor_speed] and oh[:product_processor_speed].length > 0) ? oh[:product_processor_speed] : oh[:running_processor_speed]
                          h[:memory_amount] = (oh[:total_ram] and oh[:total_ram].length > 0) ? oh[:total_ram] : oh[:individual_ram_total]
                          unless h[:battery_life] and h[:battery_life].length > 0
                            h[:battery_life] = "N/A"
                          end
                          h
                        end
  end

  def self.display_pulls
    [:build_type] + valid_pulls
  end

  def self.valid_pulls
    [:processor_product, :processor_speed, :max_L2_L3_cache, :memory_amount, :hd_size, :optical_drive, :battery_life]
  end
end
