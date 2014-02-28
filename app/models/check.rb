class Check < ActiveRecord::Base
  belongs_to :run
  has_one    :drive, through: :run
end
