require File.dirname(__FILE__) + '/../test_helper'

class SpecSheetsControllerTest < ActionController::TestCase
  fixtures :systems, :actions, :types
  REQUIRED_DATA={:contact_id => 1, :action_id => 1, :type_id => 1}

  def test_that_things_fail_if_xml_output_is_empty
    file = File.open(File.dirname(__FILE__) + "/../fixtures/empty.xml")
    get :xml_create, REQUIRED_DATA.merge({:my_file => file})
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'spec_sheets', :action => "xml_index"
  end

  def test_that_xml_system_show_does_not_show_a_nonexistant_system
    get :xml_system_show, {:id => "50"}
    assert_response :redirect
    assert_redirected_to :controller => 'spec_sheets', :action => 'xml_index', :error => "That system does not exist!"
  end

  def test_that_xml_system_show_shows_a_system
    get :xml_system_show, {:id => "1"}
    assert_response :success
  end

  def test_that_bad_xml_files_fail
    file = File.open(File.dirname(__FILE__) + "/../fixtures/bad.xml")
    get :xml_create, REQUIRED_DATA.merge({:my_file => file})
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'spec_sheets', :action => "xml_index"
  end

  def test_that_good_xml_files_succeed
    file = File.open(File.dirname(__FILE__) + "/../fixtures/1967.xml")
    get :xml_create, REQUIRED_DATA.merge({:my_file => file})
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'spec_sheets', :action => "xml_show"
  end

  def test_good_but_not_containing_any_information_xml_files_succeed
    file = File.open(File.dirname(__FILE__) + "/../fixtures/good_but_bad.xml")
    get :xml_create, REQUIRED_DATA.merge({:my_file => file})
    file.close
    assert_response :redirect
    assert_redirected_to :controller => 'spec_sheets', :action => "xml_show" #HERE
  end

  def test_that_version_client_compat_works
    get :check_compat, { :version => 1 }
    assert_tag :tag => "cli-compat", :child => { :content => "false" }
    assert_tag :tag => "ser-compat", :child => { :content => "true" }
  end

  def test_that_version_server_compat_works
    get :check_compat, { :version => 1000 }
    assert_tag :tag => "cli-compat", :child => { :content => "true" }
    assert_tag :tag => "ser-compat", :child => { :content => "false" }
  end

  def test_that_compat_works_with_right_version
    get :check_compat, {:version => SpecSheetsController::MY_VERSION}
    assert_tag :tag => "cli-compat", :child => { :content => "true" }
    assert_tag :tag => "ser-compat", :child => { :content => "true" }
  end
end
