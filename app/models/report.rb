class Report < ActiveRecord::Base
  belongs_to :contact
  belongs_to :role
  belongs_to :system
  belongs_to :type
end
