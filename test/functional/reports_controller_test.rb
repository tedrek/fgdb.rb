require File.dirname(__FILE__) + '/../test_helper'

class ReportsControllerTest < ActionController::TestCase
  def test_that_things_fail_if_xml_output_is_empty
    file = File.open(File.dirname(__FILE__) + "/../fixtures/empty.xml")
    get :xml_create, :my_file => file
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'reports', :action => "xml_index", :error => "The posted lshw output was empty!"
  end

  def test_that_xml_system_show_does_not_show_a_nonexistant_system
    get :xml_system_show, {:id => "50"}
    assert_response :redirect
    assert_redirected_to :controller => 'reports', :action => 'xml_index', :error => "That system does not exist!"
  end
  
  def test_that_xml_system_show_shows_a_system
    get :xml_system_show, {:id => "1"}
    assert_response :success
  end

  def test_that_bad_xml_files_fail
    file = File.open(File.dirname(__FILE__) + "/../fixtures/bad.xml")
    get :xml_create, :my_file => file
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'reports', :action => "xml_index", :error => "Invalid XML!"
  end

  def test_that_good_xml_files_succeed
    file = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    get :xml_create, :my_file => file
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'reports', :action => "xml_show"
  end

  def test_that_version_compat_fails
    get :check_compat, { :version => 1000 }
    assert_tag :tag => "compat", :child => { :content => "true" }
  end

  def test_that_version_compat_succeeds
    get :check_compat, { :version => 0 }
    assert_tag :tag => "compat", :child => { :content => "false" }
  end
end
