require 'ajax_scaffold'

class TillHandler < ActiveRecord::Base
  belongs_to :contact

  def to_s
    description
  end

end
