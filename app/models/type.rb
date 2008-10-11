class Type < ActiveRecord::Base
  belongs_to :creator, :foreign_key => "created_by", :class_name => "User"
  belongs_to :updator, :foreign_key => "created_by", :class_name => "User"
  validates_existence_of :creator, {:allow_nil => true}
  validates_existence_of :updator, {:allow_nil => true}
end
