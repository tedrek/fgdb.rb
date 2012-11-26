class AddDataSecurityRole < ActiveRecord::Migration
  def self.up
    p  = Privilege.new(:restrict => true, :name => "data_security")
    r = Role.new(:name => "DATA_SECURITY", :notes => "This role gives access to manage data security records for certificates of destruction")
    r.privileges << p
    r.save
    p.save
  end

  def self.down
  end
end
