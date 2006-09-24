require 'ajax_scaffold'

class Donation < ActiveRecord::Base
  belongs_to :contact
  belongs_to :payment_method
  has_many :donated_gizmos
end
