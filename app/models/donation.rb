require 'ajax_scaffold'

class Donation < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"  
  belongs_to :payment_method
  has_many :donation_lines
  has_many :gizmo_events, :through => :donation_lines

  def to_s
    id
  end
end
