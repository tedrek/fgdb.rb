class SystemPricing < ActiveRecord::Base
  has_and_belongs_to_many :pricing_values
  belongs_to :system
  belongs_to :spec_sheet
  belongs_to :pricing_type

  def needs_override?
    !! @needs_override
  end

  def spec_sheet
    s = read_attribute(:spec_sheet_id)
    return SpecSheet.find_by_id(s) if defined?(@found_spec_sheet)
    if s.nil? and self.system and self.system.spec_sheets.last
      s = self.spec_sheet_id = self.system.spec_sheets.last.id
    end
    @found_spec_sheet = true # or at least tried.
    return SpecSheet.find_by_id(s)
  end

  def valid?
    if self.spec_sheet.pricing_values[:product_processor_speed] and self.spec_sheet.pricing_values[:product_processor_speed].length > 0 and (self.spec_sheet.pricing_values[:running_processor_speed] != self.spec_sheet.pricing_values[:product_processor_speed])
      errors.add('spec_sheet_id', "detected a different running speed (#{self.spec_sheet.pricing_values[:running_processor_speed]}) than the processor product speed (#{self.spec_sheet.pricing_values[:product_processor_speed]})")
      @needs_override = true
    end
    if self.spec_sheet.pricing_values[:total_ram] and self.spec_sheet.pricing_values[:total_ram].length > 0 and (self.spec_sheet.pricing_values[:total_ram] != self.spec_sheet.pricing_values[:individual_ram_total])
      errors.add('spec_sheet_id', "detected a different total amount of memory (#{self.spec_sheet.pricing_values[:total_ram]}) than the sum of the individual banks (#{self.spec_sheet.pricing_values[:individual_ram_total]})")
      @needs_override = true
    end
  end

  def pricing_values
    @pricing_values ||= begin
                          h = {} # TODO: Remove all OH ordered hash processing, it is useless with pull list.
                          self.valid?
                          oh = self.spec_sheet.pricing_values
                          oh.each do |k, v|
                            if self.class.valid_pulls.include?(k)
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

  def self.valid_pulls
    [:processor_product, :processor_speed, :max_L2_L3_cache, :memory_amount, :hd_size, :optical_drive, :battery_life]
  end
end
