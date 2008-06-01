class SpecSheet < ActiveRecord::Base
  include XmlHelper

  attr_readonly :lshw_output

  belongs_to :contact
  belongs_to :action
  belongs_to :system
  belongs_to :type

  def initialize(*args)
    super(*args)
    if !load_xml(lshw_output)
      return false
    end
    
    @system_model = get_from_xml("/node/product")
    @system_serial_number = get_from_xml("/node/serial")
    @system_vendor = get_from_xml("/node/vendor")
    @mobo_model = get_from_xml("/node/node[@id='core']/product")
    @mobo_serial_number = get_from_xml("/node/node[@id='core']/serial")
    @mobo_vendor = get_from_xml("/node/node[@id='core']/vendor")
    @macaddr = get_from_xml("//node[@class='network']/serial")

    get_vendor
    get_serial
    get_model
    
    if @serial_number != "(no serial number)"
      found_system = System.find(:first, :conditions => {:serial_number => @serial_number, :vendor => @vendor, :model => @model}, :order => :id)
      if found_system 
        self.system = found_system
      else
        self.system = System.new
      end
    else
      self.system = System.new
    end

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
  
  def get_from_xml(xpath)
    value = xpath_value_of(xpath)
    if value == "Unknown"
      value = nil
    end
    return value
  end

  COMMON_GENERICS=['System Name', 'Product Name', 'System Manufacturer', 'none', 'None', 'To Be Filled By O.E.M.', 'To Be Filled By O.E.M. by More String']

  def is_usable(value, list_of_generics = [])
    return (value != nil && value != "" && !list_of_generics.include?(value))
  end

  def mac_is_usable(value)
    return is_usable(value)
  end

  def serial_is_usable(value)
    list_of_generics = ['0123456789ABCDEF', '0123456789', '1234567890', 'MB-1234567890', 'SYS-1234567890', '00000000', 'xxxxxxxxxx', 'xxxxxxxxxxx', 'XXXXXXXXXX', 'Serial number xxxxxx', 'EVAL', 'Serial number xxxxxx', '00000000', 'XXXXXXXXXX', '$', 'xxxxxxxxxxxx', 'xxxxxxxxxx', 'xxxxxxxxxxxx', 'xxxxxxxxxxxxxx', '0000000000', 'DELL', *COMMON_GENERICS] 
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
