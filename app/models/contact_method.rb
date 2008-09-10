class ContactMethod < ActiveRecord::Base
  belongs_to :contact_method_type
  belongs_to :contact
  validates_associated :contact, :contact_method_type
  validates_presence_of :contact, :contact_method_type

  def to_s
    value
  end

  def display
    "%s (%s)" % [value, contact_method_type.description]
  end
end
