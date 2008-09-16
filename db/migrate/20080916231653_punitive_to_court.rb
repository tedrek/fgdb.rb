class PunitiveToCourt < ActiveRecord::Migration
  def self.up
    CommunityServiceType.connection.execute("
      UPDATE community_service_types
        SET description='court'
        WHERE description='punitive' and name='punitive'
    ")
  end

  def self.down
    CommunityServiceType.connection.execute("
      UPDATE community_service_types
        SET description='punitive'
        WHERE description='court' and name='punitive'
    ")
  end
end
