class AddServer30dayExchangePolicy < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      rp = ReturnPolicy.new
      rp.name = "server"
      rp.description = "SERVERS"
      rp.text = "may be returned within 30 days for a store credit. You must provide the original receipt at the time of return, and the items must be returned in the same condition in which they were sold."
      rp.save!
      gt = GizmoType.find_by_name('server')
      gt.return_policy = rp
      gt.save!
    end
  end

  def self.down
  end
end
