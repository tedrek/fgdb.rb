class CallDistroCdAsIs < ActiveRecord::Migration
  def self.up
    d = GizmoType.find_by_name('distro_cd')
    if Default.is_pdx and !d.nil?
      d.description += "--AS-IS"
      d.save
    end
  end

  def self.down
  end
end
