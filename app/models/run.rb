class Run < ActiveRecord::Base
  belongs_to :drive
  has_many   :checks
end
