require 'ajax_scaffold'

class ForsaleItem < ActiveRecord::Base
  belongs_to :source_type
  validates_associated :source_type

  def to_s
    description
  end

end
