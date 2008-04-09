class Report < ActiveRecord::Base
  include XmlHelper

  belongs_to :contact
  belongs_to :role
  belongs_to :system
  belongs_to :type
end
