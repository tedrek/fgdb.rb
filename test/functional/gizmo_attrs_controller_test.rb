require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_attrs_controller'

# Re-raise errors caught by the controller.
class GizmoAttrsController; def rescue_action(e) raise e end; end

class GizmoAttrsControllerTest < Test::Unit::TestCase
  fixtures :gizmo_attrs

        NEW_GIZMO_ATTR = {}     # e.g. {:name => 'Test GizmoAttr', :description => 'Dummy'}
        REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

        def setup
                @controller = GizmoAttrsController.new
                @request    = ActionController::TestRequest.new
                @response   = ActionController::TestResponse.new
                # Retrieve fixtures via their name
                # @first = gizmo_attrs(:first)
                @first = GizmoAttr.find_first
        end

  def test_truth
    assert true
  end

end
