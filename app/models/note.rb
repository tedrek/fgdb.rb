class Note < ActiveRecord::Base
  belongs_to :system
  belongs_to :contact
  validates_existance_of :system
  validates_existance_of :contact
end
