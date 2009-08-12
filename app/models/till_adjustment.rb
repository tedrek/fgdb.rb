class TillAdjustment < ActiveRecord::Base
  define_amount_methods_on("adjustment")
  belongs_to :till_type
end
