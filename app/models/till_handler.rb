require 'ajax_scaffold'

class TillHandler < ActiveRecord::Base
  belongs_to :contact, :order => "surname, first_name"
  def to_s
    description
  end

end
