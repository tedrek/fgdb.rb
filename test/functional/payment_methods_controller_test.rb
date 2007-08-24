require File.dirname(__FILE__) + '/../test_helper'
require 'payment_methods_controller'

# Re-raise errors caught by the controller.
class PaymentMethodsController; def rescue_action(e) raise e end; end

class PaymentMethodsControllerTest < Test::Unit::TestCase
  fixtures :payment_methods

	NEW_PAYMENT_METHOD = {}	# e.g. {:name => 'Test PaymentMethod', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = PaymentMethodsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = payment_methods(:first)
		@first = PaymentMethod.find(:first)
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'payment_methods/component'
    payment_methods = check_attrs(%w(payment_methods))
    assert_equal PaymentMethod.find(:all).length, payment_methods.length, "Incorrect number of payment_methods shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'payment_methods/component'
    payment_methods = check_attrs(%w(payment_methods))
    assert_equal PaymentMethod.find(:all).length, payment_methods.length, "Incorrect number of payment_methods shown"
  end

  def test_create
  	payment_method_count = PaymentMethod.find(:all).length
    post :create, {:payment_method => NEW_PAYMENT_METHOD}
    payment_method, successful = check_attrs(%w(payment_method successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal payment_method_count + 1, PaymentMethod.find(:all).length, "Expected an additional PaymentMethod"
  end

  def test_create_xhr
  	payment_method_count = PaymentMethod.find(:all).length
    xhr :post, :create, {:payment_method => NEW_PAYMENT_METHOD}
    payment_method, successful = check_attrs(%w(payment_method successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal payment_method_count + 1, PaymentMethod.find(:all).length, "Expected an additional PaymentMethod"
  end

  def test_update
  	payment_method_count = PaymentMethod.find(:all).length
    post :update, {:id => @first.id, :payment_method => @first.attributes.merge(NEW_PAYMENT_METHOD)}
    payment_method, successful = check_attrs(%w(payment_method successful))
    assert successful, "Should be successful"
    payment_method.reload
   	NEW_PAYMENT_METHOD.each do |attr_name|
      assert_equal NEW_PAYMENT_METHOD[attr_name], payment_method.attributes[attr_name], "@payment_method.#{attr_name.to_s} incorrect"
    end
    assert_equal payment_method_count, PaymentMethod.find(:all).length, "Number of PaymentMethods should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	payment_method_count = PaymentMethod.find(:all).length
    xhr :post, :update, {:id => @first.id, :payment_method => @first.attributes.merge(NEW_PAYMENT_METHOD)}
    payment_method, successful = check_attrs(%w(payment_method successful))
    assert successful, "Should be successful"
    payment_method.reload
   	NEW_PAYMENT_METHOD.each do |attr_name|
      assert_equal NEW_PAYMENT_METHOD[attr_name], payment_method.attributes[attr_name], "@payment_method.#{attr_name.to_s} incorrect"
    end
    assert_equal payment_method_count, PaymentMethod.find(:all).length, "Number of PaymentMethods should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	payment_method_count = PaymentMethod.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal payment_method_count - 1, PaymentMethod.find(:all).length, "Number of PaymentMethods should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	payment_method_count = PaymentMethod.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal payment_method_count - 1, PaymentMethod.find(:all).length, "Number of PaymentMethods should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
