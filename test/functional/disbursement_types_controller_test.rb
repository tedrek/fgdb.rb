require File.dirname(__FILE__) + '/../test_helper'
require 'disbursement_types_controller'

# Re-raise errors caught by the controller.
class DisbursementTypesController; def rescue_action(e) raise e end; end

class DisbursementTypesControllerTest < Test::Unit::TestCase
  fixtures :disbursement_types

  def setup
    @controller = DisbursementTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_truth
    assert true
  end

end
