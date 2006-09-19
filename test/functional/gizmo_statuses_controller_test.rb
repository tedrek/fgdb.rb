require File.dirname(__FILE__) + '/../test_helper'
require '/gizmo_statuses_controller'

# Re-raise errors caught by the controller.
class GizmoStatusesController; def rescue_action(e) raise e end; end

class GizmoStatusesControllerTest < Test::Unit::TestCase
  fixtures :gizmo_statuses

  def setup
    @controller = GizmoStatusesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
