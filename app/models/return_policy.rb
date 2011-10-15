class ReturnPolicy < ActiveRecord::Base
  def full_text
    self.description.upcase + ": " + self.text
  end
end
