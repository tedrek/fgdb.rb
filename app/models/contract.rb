class Contract < ActiveRecord::Base
  named_scope :usable, :conditions => {:instantiable => true}
end
