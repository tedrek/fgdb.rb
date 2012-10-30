class CommunityServiceType < ActiveRecord::Base
  def display_name
    description
  end

  def to_s
    display_name
  end
end
