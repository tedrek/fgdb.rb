class CommunityServiceType < ActiveRecord::Base
  def display_name
    description
  end
end
