require File.dirname(__FILE__) + '/../test_helper'
require 'defaults_controller'

# Re-raise errors caught by the controller.
class DefaultsController; def rescue_action(e) raise e end; end

class DefaultsControllerTest < Test::Unit::TestCase
  fixtures :defaults

  def setup
    @controller = DefaultsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

end
