require 'ajax_scaffold'

class ContactType < ActiveRecord::Base
  has_and_belongs_to_many :contacts
  validates_uniqueness_of :description, :message => "already exists"
  # acts_as_userstamp

  def to_s
    description
  end

  def long_for_who
    case for_who
    when 'per'
      'person'
    when 'org'
      'organization'
    else
      for_who
    end
  end

end
