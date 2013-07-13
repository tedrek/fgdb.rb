class Contract < ActiveRecord::Base
  scope :usable, where(:instantiable => true)
end
