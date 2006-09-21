require 'ajax_scaffold'

class ContactType < ActiveRecord::Base
  has_and_belongs_to_many :contacts
  validates_uniqueness_of :description, :message => "already exists"
  # acts_as_userstamp

  def to_s
    description
  end
end
