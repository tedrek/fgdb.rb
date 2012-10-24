class DiscountPercentage < ActiveRecord::Base
  def description
    self.percentage ? self.percentage.to_s+'%' : "Sale"
  end
end
