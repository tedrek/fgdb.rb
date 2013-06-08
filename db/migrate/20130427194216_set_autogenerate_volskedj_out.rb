class SetAutogenerateVolskedjOut < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      Default["autogenerate_volskedj_out"] = "4.weeks"
    end
  end

  def self.down
  end
end
