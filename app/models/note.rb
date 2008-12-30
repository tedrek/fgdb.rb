class Note < ActiveRecord::Base
  belongs_to :system
  belongs_to :contact
  validates_existence_of :system
  validates_existence_of :contact
end
