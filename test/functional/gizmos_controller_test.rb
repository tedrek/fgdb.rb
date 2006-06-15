require File.dirname(__FILE__) + '/../test_helper'
require '/gizmos_controller'

# Re-raise errors caught by the controller.
class GizmosController; def rescue_action(e) raise e end; end

class GizmosControllerTest < Test::Unit::TestCase
  fixtures :gizmos

  def setup
    @controller = GizmosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
