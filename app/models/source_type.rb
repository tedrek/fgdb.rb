require 'ajax_scaffold'

class SourceType < ActiveRecord::Base
  validates_uniqueness_of :description, :message => "already exists"

  def to_s
    description
  end
end
