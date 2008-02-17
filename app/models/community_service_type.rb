class CommunityServiceType < ActiveRecord::Base

  has_many :volunteer_tasks

  def display_name
    description
  end
end
