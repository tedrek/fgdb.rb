require File.dirname(__FILE__) + '/../test_helper'
require 'sidebar_links_controller'

# Re-raise errors caught by the controller.
class SidebarLinksController; def rescue_action(e) raise e end; end

class SidebarLinksControllerTest < Test::Unit::TestCase
  def setup
    @controller = SidebarLinksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
