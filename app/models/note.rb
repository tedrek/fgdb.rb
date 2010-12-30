class Note < ActiveRecord::Base
  include SystemHelper

  belongs_to :system
  belongs_to :contact
  validates_existence_of :system
  validates_existence_of :contact

  attr_accessor :lshw_output

  before_validation :set_system

  def set_system
    if !self.system
      sp = SystemParser.parse(lshw_output)

      found_system = sp.find_system_id
      if found_system
        self.system = System.find_by_id(found_system)
      else
        self.system = System.new
        system.system_model  = sp.system_model
        system.system_serial_number  = sp.system_serial_number
        system.system_vendor  = sp.system_vendor
        system.mobo_model  = sp.mobo_model
        system.mobo_serial_number  = sp.mobo_serial_number
        system.mobo_vendor  = sp.mobo_vendor
        system.model  = sp.model
        system.serial_number  = sp.serial_number
        system.vendor  = sp.vendor
      end
    end
  end
end
