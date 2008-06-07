require File.dirname(__FILE__) + '/../test_helper'

class ReportsControllerTest < ActionController::TestCase
  def test_that_version_reports_correctly
    def test_that_version_compat_fails
      get :check_compat, { :version => 1000 }
      assert_tag :tag => "compat", :child => { :content => "true" }
    end
  end
end
