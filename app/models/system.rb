class System < ActiveRecord::Base
  attr_protected :mobo_vendor, :system_vendor, :mobo_serial_number, :system_serial_number, :mobo_model, :system_model, :vendor, :serial_number, :model
  attr_readonly :mobo_vendor, :system_vendor, :mobo_serial_number, :system_serial_number, :mobo_model, :system_model, :vendor, :serial_number, :model
  validates_presence_of :vendor, :serial_number, :model

  belongs_to :creator, :foreign_key => "created_by", :class_name => "User"
  belongs_to :updator, :foreign_key => "created_by", :class_name => "User"
  validates_existence_of :creator, {:allow_nil => true}
  validates_existence_of :updator, {:allow_nil => true}
end
