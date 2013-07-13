class Type < ActiveRecord::Base
  scope :usable
  has_and_belongs_to_many :pricing_types
  belongs_to :gizmo_type
end
