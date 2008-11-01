class System < ActiveRecord::Base
  belongs_to :contract
  attr_protected :mobo_vendor, :system_vendor, :mobo_serial_number, :system_serial_number, :mobo_model, :system_model, :vendor, :serial_number, :model
  attr_readonly :mobo_vendor, :system_vendor, :mobo_serial_number, :system_serial_number, :mobo_model, :system_model, :vendor, :serial_number, :model
  validates_presence_of :vendor, :serial_number, :model
  validates_existence_of :contract

  acts_as_userstamp
end
