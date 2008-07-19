class ContactMethod < ActiveRecord::Base
  belongs_to :contact_method_type
  belongs_to :contact
  validates_associated :contact, :contact_method_type
  validates_presence_of :contact, :contact_method_type

  def to_s
    description
  end

  def is_usable
    ok
  end

  def display
    "%s (%s)" % [description, contact_method_type.description]
  end
end
