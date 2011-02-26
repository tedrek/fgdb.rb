class TrackBuilderProgress < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      for i in ["completed_hardware_id", "completed_system_eval"]
        ContactType.new(:for_who => "per", :name => i, :description => i.split(/_/).map{|x| x.titleize}.join(" "), :instantiable => true).save!
      end
    end

    add_column "spec_sheets", "cashier_signed_off_by", :integer
    add_foreign_key "spec_sheets", "cashier_signed_off_by", "users", "id", :on_delete => :restrict

    p = Privilege.new(:name => "sign_off_spec_sheets")
    p.save!
    r = Role.new(:name => "BUILD_INSTRUCTOR")
    r.privileges << p
    r.save!
  end

  def self.down
  end
end
