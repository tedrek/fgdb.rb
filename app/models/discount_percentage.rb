class DiscountPercentage < ActiveRecord::Base
  def description
    self.percentage.to_s+'%'
  end
end
