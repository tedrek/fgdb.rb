require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < ActiveSupport::TestCase
  def test_that_generics_are_detected
    file = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    report = Report.new(:lshw_output => file.read)
    file.close
    report.save
    assert_kind_of System, report.system
    assert_nothing_raised {report.system.serial_number}
    assert_equal "00:40:ca:31:d2:e8", report.system.serial_number
  end
end
