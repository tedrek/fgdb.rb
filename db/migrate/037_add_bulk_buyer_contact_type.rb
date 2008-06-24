class AddBulkBuyerContactType < ActiveRecord::Migration
  def self.up
    if ContactType.find(:first, :conditions=>"description='bulk buyer'").nil?()
      ContactType.new(:description=>'bulk buyer',
                      :for_who=>'any'
                     ).save()
    end
  end

  def self.down
    x = ContactType.find(:first, :conditions=>"description='bulk buyer'")
    unless x.nil?
      x.destroy()
    end
  end
end
