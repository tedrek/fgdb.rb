require File.dirname(__FILE__) + '/../test_helper'
require 'transaction_controller'

# Re-raise errors caught by the controller.
class TransactionController; def rescue_action(e) raise e end; end

class TransactionControllerTest < Test::Unit::TestCase
  def setup
    @controller = TransactionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
end
