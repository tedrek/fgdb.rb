class DisktestAPI < SOAP::SoapsBase
  include ApplicationHelper

  def add_methods
    for i in soap_methods
      add_method(*i)
    end
  end

  def soap_methods
    [
    # soap_methods access
    ["soap_methods"],
    # Connection Testing
    ["ping"],
    # Lists
    ["add_disktest_run", "vendor", "model", "serial_number", "size"],
    ["add_disktest_result", "id", "status"],
    ]
  end

  ######################
  # Connection Testing #
  ######################

  def ping
#    return error("BOO")
    "pong"
  end

  #########
  # Lists #
  #########

  public
  def add_disktest_run(vendor, model, serial_number, size = nil)
    dr = DisktestRun.new
    dr.vendor = vendor
    dr.model = model
    dr.serial_number = serial_number
    dr.megabytes_size = size
    dr.save!
    return dr.id
  end

  def add_disktest_result(id, result)
    dr = DisktestRun.find(id.to_i)
    dr.result = result
    dr.completed_at = Time.now
    dr.save!
    return
  end
end
