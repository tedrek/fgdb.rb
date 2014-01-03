class Drive < ActiveRecord::Base
  has_many :runs
  has_many :checks, through: :runs
end
