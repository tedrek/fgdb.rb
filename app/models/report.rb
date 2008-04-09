class Report < ActiveRecord::Base
  include XmlHelper

  belongs_to :contact
  belongs_to :role
  belongs_to :system
  belongs_to :type

  def save
    if super
      load_xml(lshw_output)

      system.system_model = get_from_xml("/node/product")
      system.system_serial_number = get_from_xml("/node/serial")
      system.system_vendor = get_from_xml("/node/vendor")
      system.mobo_model = get_from_xml("/node/node[@id='core']/product")
      system.mobo_serial_number = get_from_xml("/node/node[@id='core']/serial")
      system.mobo_vendor = get_from_xml("/node/node[@id='core']/vendor")

      macaddr = get_from_xml("//node[@class='network']/serial")

      if system.system_vendor
        system.vendor = system.system_vendor
      elsif system.mobo_vendor 
        system.vendor = system.mobo_vendor
      else
        system.vendor = "(no vendor)"
      end

      if system.system_model
        system.model = system.system_model
      elsif system.mobo_model
        system.model = system.mobo_model
      else
        system.model = "(no model)"
      end

      if is_usable(system.system_serial_number)
        system.serial_number = system.system_serial_number
      elsif is_usable(system.mobo_serial_number)
        system.serial_number = system.mobo_serial_number
      elsif is_usable(macaddr)
        system.serial_number = macaddr
      else
        system.serial_number = "(no serial number)"
      end
    else
      return false
    end
    return system.save
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
    list_of_generics = []
    return (value != nil && value != "" && list_of_generics.delete(value) == nil)
  end

  def future_is_usable(value)
    return (value != nil && value != "" && GenericSerialNumber.find_by_name(value) == ActiveRecord::RecordNotFound)
  end
end
