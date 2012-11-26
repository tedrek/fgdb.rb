class AddEditDisbursementsToFrontDeskRole < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      r = Role.find_by_name('FRONT_DESK')
      p = Privilege.find_by_name('change_disbursements')
      if p and r
        r.privileges << p
        r.save!
      else
        raise "ERROR: not found (p: #{p.inspect}, r: #{r.inspect})"
      end
    end
  end

  def self.down
  end
end
