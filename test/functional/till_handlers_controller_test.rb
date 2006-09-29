require File.dirname(__FILE__) + '/../test_helper'
require 'till_handlers_controller'

# Re-raise errors caught by the controller.
class TillHandlersController; def rescue_action(e) raise e end; end

class TillHandlersControllerTest < Test::Unit::TestCase
  fixtures :till_handlers

	NEW_TILL_HANDLER = {}	# e.g. {:name => 'Test TillHandler', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = TillHandlersController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = till_handlers(:first)
		@first = TillHandler.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'till_handlers/component'
    till_handlers = check_attrs(%w(till_handlers))
    assert_equal TillHandler.find(:all).length, till_handlers.length, "Incorrect number of till_handlers shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'till_handlers/component'
    till_handlers = check_attrs(%w(till_handlers))
    assert_equal TillHandler.find(:all).length, till_handlers.length, "Incorrect number of till_handlers shown"
  end

  def test_create
  	till_handler_count = TillHandler.find(:all).length
    post :create, {:till_handler => NEW_TILL_HANDLER}
    till_handler, successful = check_attrs(%w(till_handler successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal till_handler_count + 1, TillHandler.find(:all).length, "Expected an additional TillHandler"
  end

  def test_create_xhr
  	till_handler_count = TillHandler.find(:all).length
    xhr :post, :create, {:till_handler => NEW_TILL_HANDLER}
    till_handler, successful = check_attrs(%w(till_handler successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal till_handler_count + 1, TillHandler.find(:all).length, "Expected an additional TillHandler"
  end

  def test_update
  	till_handler_count = TillHandler.find(:all).length
    post :update, {:id => @first.id, :till_handler => @first.attributes.merge(NEW_TILL_HANDLER)}
    till_handler, successful = check_attrs(%w(till_handler successful))
    assert successful, "Should be successful"
    till_handler.reload
   	NEW_TILL_HANDLER.each do |attr_name|
      assert_equal NEW_TILL_HANDLER[attr_name], till_handler.attributes[attr_name], "@till_handler.#{attr_name.to_s} incorrect"
    end
    assert_equal till_handler_count, TillHandler.find(:all).length, "Number of TillHandlers should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	till_handler_count = TillHandler.find(:all).length
    xhr :post, :update, {:id => @first.id, :till_handler => @first.attributes.merge(NEW_TILL_HANDLER)}
    till_handler, successful = check_attrs(%w(till_handler successful))
    assert successful, "Should be successful"
    till_handler.reload
   	NEW_TILL_HANDLER.each do |attr_name|
      assert_equal NEW_TILL_HANDLER[attr_name], till_handler.attributes[attr_name], "@till_handler.#{attr_name.to_s} incorrect"
    end
    assert_equal till_handler_count, TillHandler.find(:all).length, "Number of TillHandlers should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	till_handler_count = TillHandler.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal till_handler_count - 1, TillHandler.find(:all).length, "Number of TillHandlers should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	till_handler_count = TillHandler.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal till_handler_count - 1, TillHandler.find(:all).length, "Number of TillHandlers should be one less"
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
