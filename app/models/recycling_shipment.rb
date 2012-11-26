class RecyclingShipment < ActiveRecord::Base
  belongs_to :contact
  validates_presence_of :contact_id
  validates_existence_of :contact
  validates_presence_of :bill_of_lading
  validates_presence_of :received_at
end
