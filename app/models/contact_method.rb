require 'ajax_scaffold'

class ContactMethod < ActiveRecord::Base
  belongs_to :contact_method_type
  validates_associated :contact_method_type
  belongs_to :contact
  validates_associated :contact
  # acts_as_userstamp
end
