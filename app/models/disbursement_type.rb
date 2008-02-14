class DisbursementType < ActiveRecord::Base
  usesguid

  def to_s
    description
  end
end
