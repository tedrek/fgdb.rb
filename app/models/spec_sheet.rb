class SpecSheet < ActiveRecord::Base
  include XmlHelper

  validates_presence_of :contact_id
  validates_presence_of :action_id
  validates_presence_of :type_id

  belongs_to :contact
  belongs_to :action
  belongs_to :system
  belongs_to :type

  validates_existence_of :type
  validates_existence_of :action
  validates_existence_of :contact

  def lshw_output=(val)
    write_attribute(:original_output, val)
    write_attribute(:original_valid, (load_xml(original_output) ? true : false))
    write_attribute(:cleaned_output, val.gsub(/[^[:print:]]/, ''))
    write_attribute(:cleaned_valid, (load_xml(cleaned_output) ? true : false))
  end

  def lshw_output
    if cleaned_valid
      return cleaned_output
    elsif original_valid
      return original_output
    else
      return ""
    end
  end

  def validate
    if @bad_xml
      errors.add("lshw_output", "is invalid XML")
    end
  end

  def initialize(*args)
    super(*args)

    if !(@parser = load_xml(lshw_output))
      @bad_xml = true
      return
    end

    @parser.xml_foreach("class", "system") {
      @system_model ||= @parser._xml_value_of("product", '/')
      @system_serial_number ||= @parser._xml_value_of("serial", '/')
      @system_vendor ||= @parser._xml_value_of("vendor", '/')
      @mobo_model ||= @parser.xml_first("id", "core") do @parser._xml_value_of("product", '/') end
      @mobo_serial_number ||= @parser.xml_first("id", "core") do @parser._xml_value_of("serial", '/') end
      @mobo_vendor ||= @parser.xml_first("id", "core") do @parser._xml_value_of("vendor", '/') end
      @macaddr ||= @parser.xml_first("id", "network") do @parser._xml_value_of("serial", '/') end
    }

    get_vendor
    get_serial
    get_model

    if @serial_number != "(no serial number)" && (found_system = System.find(:first, :conditions => {:serial_number => @serial_number, :vendor => @vendor, :model => @model}, :order => :id))
      self.system = found_system
    else
      self.system = System.new
      system.system_model  = @system_model
      system.system_serial_number  = @system_serial_number
      system.system_vendor  = @system_vendor
      system.mobo_model  = @mobo_model
      system.mobo_serial_number  = @mobo_serial_number
      system.mobo_vendor  = @mobo_vendor
      system.model  = @model
      system.serial_number  = @serial_number
      system.vendor  = @vendor
    end
  end

  #######
  private
  #######

  def get_model
      if model_is_usable(@system_model)
        @model = @system_model
      elsif model_is_usable(@mobo_model)
        @model = @mobo_model
      else
        @model = "(no model)"
      end
    return @model
  end

  def get_vendor
      if vendor_is_usable(@system_vendor)
        @vendor = @system_vendor
      elsif vendor_is_usable(@mobo_vendor)
        @vendor = @mobo_vendor
      else
        @vendor = "(no vendor)"
      end
    return @vendor
  end

  def get_serial
      if serial_is_usable(@system_serial_number)
        @serial_number = @system_serial_number
      elsif serial_is_usable(@mobo_serial_number)
        @serial_number = @mobo_serial_number
      elsif mac_is_usable(@macaddr)
        @serial_number = @macaddr
      else
        @serial_number = "(no serial number)"
      end
    return @serial_number
  end

  COMMON_GENERICS=['System Name', 'Product Name', 'System Manufacturer', 'none', 'None', 'To Be Filled By O.E.M.', 'To Be Filled By O.E.M. by More String']

  def is_usable(value, list_of_generics = [])
    return (value != nil && value != "" && !list_of_generics.include?(value))
  end

  def mac_is_usable(value)
    return is_usable(value)
  end

  def serial_is_usable(value)
    list_of_generics = ['�����', '0123456789ABCDEF', '0123456789', '1234567890', 'MB-1234567890', 'SYS-1234567890', '00000000', 'xxxxxxxxxx', 'xxxxxxxxxxx', 'XXXXXXXXXX', 'Serial number xxxxxx', 'EVAL', 'Serial number xxxxxx', '00000000', 'XXXXXXXXXX', '$', 'xxxxxxxxxxxx', 'xxxxxxxxxx', 'xxxxxxxxxxxx', 'xxxxxxxxxxxxxx', '0000000000', 'DELL', '0', *COMMON_GENERICS]
    return is_usable(value, list_of_generics)
  end

  def vendor_is_usable(value)
    list_of_generics = COMMON_GENERICS
    return is_usable(value, list_of_generics)
  end

  def model_is_usable(value)
    list_of_generics = COMMON_GENERICS
    return is_usable(value, list_of_generics)
  end
end
