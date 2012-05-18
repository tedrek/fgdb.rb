class DisktestRun < ActiveRecord::Base
  def self.is_running?(vendor, model, serial)
    last = self.find_last_run(vendor, model, serial)
    return !! (last && last.running?)
  end

  def self.find_last_run(vendor, model, serial)
    self.find_all_by_vendor_and_model_and_serial_number(vendor, model, serial).sort_by(&:created_at).last
  end

  def running?
    result == nil
  end
end
