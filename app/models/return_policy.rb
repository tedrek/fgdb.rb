class ReturnPolicy < ActiveRecord::Base
  def full_text
    self.description.upcase + ": " + self.text
  end

  def normal_description
    self.description.titleize
  end
end
