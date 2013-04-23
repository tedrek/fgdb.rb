class ProcdbAPI < SOAP::SoapsBase
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
    ["find_results", "cpu"],
    ["display_fields"]
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
  def display_fields
    ["Brand", "Model", "Cores", "Clock Speed", "Spec Level", "Release Date"]
  end

  def find_results(cpu_name)
    return PricingData.lookup_proc(cpu_name)
  end
end
