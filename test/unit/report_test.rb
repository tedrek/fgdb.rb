require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < ActiveSupport::TestCase
  fixtures :reports, :systems

  def setup
    Report.connection.execute "DELETE FROM reports"
    System.connection.execute "DELETE FROM systems"
  end

  def test_that_generics_are_detected(stop = 0)
    file = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    report = Report.new(:lshw_output => file.read)
    file.close
    report.save
    assert_kind_of System, report.system
    assert_nothing_raised {report.system.serial_number}
    assert_equal "00:40:ca:31:d2:e8", report.system.serial_number
    assert_nothing_raised {report.system.model}
    assert_equal "First International Computer, Inc.", report.system.vendor
    assert_nothing_raised {report.system.model}
    assert_equal "AT31", report.system.model
    test_that_generics_are_detected(stop + 1) unless stop == 3
  end

  def test_that_same_xml_produces_same_systems
    file = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    data = file.read
    file.close
    report1 = Report.new(:lshw_output => data)
    report1.save
    report2 = Report.new(:lshw_output => data)
    assert report2.get_serial != "(no serial number)"
    assert report2.get_serial == report1.get_serial
    assert_equal 1, System.find_all_by_serial_number(report2.get_serial).length 
    assert_equal report1.system.id, report2.system.id
    report2.save
    assert_equal report1.get_serial, report2.get_serial
    assert_equal System.find_all_by_serial_number(report1.get_serial)[0].id, System.find_all_by_serial_number(report2.get_serial)[0].id
    assert_equal System.find_all_by_serial_number(report1.get_serial).length, System.find_all_by_serial_number(report2.get_serial).length
    assert_nothing_raised {report1.system.id}
    assert_nothing_raised {report2.system.id}
    assert_equal report1.system.id, report2.system.id
  end
end
