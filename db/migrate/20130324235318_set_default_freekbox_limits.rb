class SetDefaultFreekboxLimits < ActiveRecord::Migration
  def self.up
    Default["freekbox_proc_expect"] = "Intel(R) Core(TM)2 Duo"
    Default["freekbox_ram_expect"] = "1.0gb"
    Default["freekbox_hd_min"] = "120gb"
    Default["freekbox_hd_max"] = "160gb"
  end

  def self.down
  end
end
