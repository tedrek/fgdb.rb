class CommunityServiceType < ActiveRecord::Base
  usesguid

  has_many :volunteer_tasks

  def display_name
    description
  end
end
