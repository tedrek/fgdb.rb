class RecyclingShipment < ActiveRecord::Base
  validates_presence_of :contact_id
  validates_presence_of :bill_of_lading
  validates_presence_of :received_at
  belongs_to :contact
end
