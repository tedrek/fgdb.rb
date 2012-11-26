class Program < ActiveRecord::Base
  def to_s
    description
  end

  def display_name
    description.downcase
  end
end
