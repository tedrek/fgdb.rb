class ContactMethod < ActiveRecord::Base

  belongs_to :contact_method_type
  belongs_to :contact, :order => "surname, first_name"  
  validates_associated :contact, :contact_method_type
  validates_presence_of :contact, :contact_method_type
  # acts_as_userstamp

  def to_s
    description
  end

  def display
    "%s (%s)" % [description, contact_method_type.description]
  end
end
