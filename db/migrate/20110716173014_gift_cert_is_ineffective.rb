class GiftCertIsIneffective < ActiveRecord::Migration
  def self.up
    if Default.is_pdx && gt = GizmoType.find_by_name('gift_cert')
      gt.ineffective_on = Date.yesterday
      gt.save
    end
  end

  def self.down
  end
end
