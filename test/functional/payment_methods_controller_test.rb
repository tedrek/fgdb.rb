require File.dirname(__FILE__) + '/../test_helper'
require 'payment_methods_controller'

# Re-raise errors caught by the controller.
class PaymentMethodsController; def rescue_action(e) raise e end; end

class PaymentMethodsControllerTest < Test::Unit::TestCase
  fixtures :payment_methods

        NEW_PAYMENT_METHOD = {} # e.g. {:name => 'Test PaymentMethod', :description => 'Dummy'}
        REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

        def setup
                @controller = PaymentMethodsController.new
                @request    = ActionController::TestRequest.new
                @response   = ActionController::TestResponse.new
                # Retrieve fixtures via their name
                # @first = payment_methods(:first)
                @first = PaymentMethod.find(:first)
        end

  def test_truth
    assert true
  end

end
