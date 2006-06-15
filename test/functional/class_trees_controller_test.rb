require File.dirname(__FILE__) + '/../test_helper'
require '/class_trees_controller'

# Re-raise errors caught by the controller.
class ClassTreesController; def rescue_action(e) raise e end; end

class ClassTreesControllerTest < Test::Unit::TestCase
  fixtures :class_trees

  def setup
    @controller = ClassTreesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
