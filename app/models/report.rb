class Report < ActiveRecord::Base
  include XmlHelper

  attr_readonly :lshw_output

  belongs_to :contact
  belongs_to :role
  belongs_to :system
  belongs_to :type

  def get_model
      if is_usable(@system_model)
        @model = @system_model
      elsif is_usable(@mobo_model)
        @model = @mobo_model
      else
        @model = "(no model)"
      end
    return @model
  end

  def get_vendor
      if is_usable(@system_vendor)
        @vendor = @system_vendor
      elsif is_usable(@mobo_vendor)
        @vendor = @mobo_vendor
      else
        @vendor = "(no vendor)"
      end
    return @vendor
  end

  def get_serial
      if is_usable(@system_serial_number)
        @serial_number = @system_serial_number
      elsif is_usable(@mobo_serial_number)
        @serial_number = @mobo_serial_number
      elsif is_usable(@macaddr)
        @serial_number = @macaddr
      else
        @serial_number = "(no serial number)"
      end
    return @serial_number
  end

  def init
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
  end

  def save
    if super
    init
    get_vendor
    get_serial
    get_model
      system.system_model  = @system_model 
      system.system_serial_number  = @system_serial_number 
      system.system_vendor  = @system_vendor 
      system.mobo_model  = @mobo_model 
      system.mobo_serial_number  = @mobo_serial_number 
      system.mobo_vendor  = @mobo_vendor 
      system.model  = @model 
      system.serial_number  = @serial_number 
      system.vendor  = @vendor 
      return system.save
    else
      return false
    end
  end

  private

  def get_from_xml(xpath)
    value = xpath_value_of(xpath)
    if value == "Unknown"
      value = nil
    end
    return value
  end

  def is_usable(value)
    list_of_generics = ['0123456789ABCDEF', '0123456789', '1234567890', 'MB-1234567890', 'SYS-1234567890', '00000000', 'xxxxxxxxxx', 'xxxxxxxxxxx', 'XXXXXXXXXX', 'Serial number xxxxxx', 'To Be Filled By O.E.M.', 'System Manufacturer', 'System Name', 'EVAL', 'Serial number xxxxxx', 'To Be Filled By O.E.M. by More String', 'To Be Filled By O.E.M.', 'System Manufacturer', 'System Name', '00000000', 'XXXXXXXXXX', '$', 'xxxxxxxxxxxx', 'xxxxxxxxxx', 'xxxxxxxxxxxx', 'xxxxxxxxxxxxxx', '0000000000', 'None', 'DELL', 'none'] ###Make a separate for serial numbers, vendors, and models before integrated into fgdb.rb
    return (value != nil && value != "" && list_of_generics.delete(value) == nil)
  end

  def future_is_usable(value)
    return (value != nil && value != "" && GenericSerialNumber.find_by_name(value) == ActiveRecord::RecordNotFound)
  end
end
