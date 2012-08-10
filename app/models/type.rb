class Type < ActiveRecord::Base
  named_scope :usable
  belongs_to :pricing_type
end
