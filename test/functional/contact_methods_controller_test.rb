require File.dirname(__FILE__) + '/../test_helper'
require 'contact_methods_controller'

# Re-raise errors caught by the controller.
class ContactMethodsController; def rescue_action(e) raise e end; end

class ContactMethodsControllerTest < Test::Unit::TestCase
  fixtures :contact_methods

	NEW_CONTACT_METHOD = {}	# e.g. {:name => 'Test ContactMethod', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = ContactMethodsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = contact_methods(:first)
		@first = ContactMethod.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'contact_methods/component'
    contact_methods = check_attrs(%w(contact_methods))
    assert_equal ContactMethod.find(:all).length, contact_methods.length, "Incorrect number of contact_methods shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'contact_methods/component'
    contact_methods = check_attrs(%w(contact_methods))
    assert_equal ContactMethod.find(:all).length, contact_methods.length, "Incorrect number of contact_methods shown"
  end

  def test_create
  	contact_method_count = ContactMethod.find(:all).length
    post :create, {:contact_method => NEW_CONTACT_METHOD}
    contact_method, successful = check_attrs(%w(contact_method successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal contact_method_count + 1, ContactMethod.find(:all).length, "Expected an additional ContactMethod"
  end

  def test_create_xhr
  	contact_method_count = ContactMethod.find(:all).length
    xhr :post, :create, {:contact_method => NEW_CONTACT_METHOD}
    contact_method, successful = check_attrs(%w(contact_method successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal contact_method_count + 1, ContactMethod.find(:all).length, "Expected an additional ContactMethod"
  end

  def test_update
  	contact_method_count = ContactMethod.find(:all).length
    post :update, {:id => @first.id, :contact_method => @first.attributes.merge(NEW_CONTACT_METHOD)}
    contact_method, successful = check_attrs(%w(contact_method successful))
    assert successful, "Should be successful"
    contact_method.reload
   	NEW_CONTACT_METHOD.each do |attr_name|
      assert_equal NEW_CONTACT_METHOD[attr_name], contact_method.attributes[attr_name], "@contact_method.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_method_count, ContactMethod.find(:all).length, "Number of ContactMethods should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	contact_method_count = ContactMethod.find(:all).length
    xhr :post, :update, {:id => @first.id, :contact_method => @first.attributes.merge(NEW_CONTACT_METHOD)}
    contact_method, successful = check_attrs(%w(contact_method successful))
    assert successful, "Should be successful"
    contact_method.reload
   	NEW_CONTACT_METHOD.each do |attr_name|
      assert_equal NEW_CONTACT_METHOD[attr_name], contact_method.attributes[attr_name], "@contact_method.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_method_count, ContactMethod.find(:all).length, "Number of ContactMethods should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	contact_method_count = ContactMethod.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal contact_method_count - 1, ContactMethod.find(:all).length, "Number of ContactMethods should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	contact_method_count = ContactMethod.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_method_count - 1, ContactMethod.find(:all).length, "Number of ContactMethods should be one less"
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
