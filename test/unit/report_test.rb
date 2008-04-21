require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < ActiveSupport::TestCase
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

  def test_that_different_xml_files_produce_different_systems
    file1 = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    data1 = file1.read
    file1.close
    file2 = File.open(File.dirname(__FILE__) + "/../fixtures/1967_different_vendor_model.xml")
    data2 = file2.read
    file2.close
    file3 = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    data3 = file3.read
    file3.close
    file4 = File.open(File.dirname(__FILE__) + "/../fixtures/1967_different_serial.xml")
    data4 = file4.read
    file4.close
    report1 = Report.new(:lshw_output => data1)
    report1.save
    report2 = Report.new(:lshw_output => data2)
    report2.save
    report3 = Report.new(:lshw_output => data3)
    report3.save
    report4 = Report.new(:lshw_output => data4)
    report4.save
    assert_equal report1.system.id, report3.system.id
    assert_not_equal report1.system.id, report2.system.id
    assert_not_equal report3.system.id, report4.system.id
    assert_not_equal report2.system.id, report4.system.id
    assert_not_equal report1.system.id, report4.system.id
    assert_not_equal report2.system.id, report3.system.id
  end
end
