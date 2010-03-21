class PointsTrade < ActiveRecord::Base
  belongs_to :from_contact, :class_name => "Contact"
  belongs_to :to_contact, :class_name => "Contact"
end
