require File.dirname(__FILE__) + '/../test_helper'
require 'contact_method_types_controller'

# Re-raise errors caught by the controller.
class ContactMethodTypesController; def rescue_action(e) raise e end; end

class ContactMethodTypesControllerTest < Test::Unit::TestCase
  fixtures :contact_method_types

  NEW_CONTACT_METHOD_TYPE = {}  # e.g. {:name => 'Test ContactMethodType', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = ContactMethodTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = contact_method_types(:first)
    @first = ContactMethodType.find_first
  end

  def test_component
    get :component
    assert_response :success
    assert_template 'contact_method_types/component'
    contact_method_types = check_attrs(%w(contact_method_types))
    assert_equal ContactMethodType.find(:all).length, contact_method_types.length, "Incorrect number of contact_method_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'contact_method_types/component'
    contact_method_types = check_attrs(%w(contact_method_types))
    assert_equal ContactMethodType.find(:all).length, contact_method_types.length, "Incorrect number of contact_method_types shown"
  end

  def test_create
    contact_method_type_count = ContactMethodType.find(:all).length
    post :create, {:contact_method_type => NEW_CONTACT_METHOD_TYPE}
    contact_method_type, successful = check_attrs(%w(contact_method_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal contact_method_type_count + 1, ContactMethodType.find(:all).length, "Expected an additional ContactMethodType"
  end

  def test_create_xhr
    contact_method_type_count = ContactMethodType.find(:all).length
    xhr :post, :create, {:contact_method_type => NEW_CONTACT_METHOD_TYPE}
    contact_method_type, successful = check_attrs(%w(contact_method_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal contact_method_type_count + 1, ContactMethodType.find(:all).length, "Expected an additional ContactMethodType"
  end

  def test_update
    contact_method_type_count = ContactMethodType.find(:all).length
    post :update, {:id => @first.id, :contact_method_type => @first.attributes.merge(NEW_CONTACT_METHOD_TYPE)}
    contact_method_type, successful = check_attrs(%w(contact_method_type successful))
    assert successful, "Should be successful"
    contact_method_type.reload
     NEW_CONTACT_METHOD_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_METHOD_TYPE[attr_name], contact_method_type.attributes[attr_name], "@contact_method_type.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_method_type_count, ContactMethodType.find(:all).length, "Number of ContactMethodTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
    contact_method_type_count = ContactMethodType.find(:all).length
    xhr :post, :update, {:id => @first.id, :contact_method_type => @first.attributes.merge(NEW_CONTACT_METHOD_TYPE)}
    contact_method_type, successful = check_attrs(%w(contact_method_type successful))
    assert successful, "Should be successful"
    contact_method_type.reload
     NEW_CONTACT_METHOD_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_METHOD_TYPE[attr_name], contact_method_type.attributes[attr_name], "@contact_method_type.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_method_type_count, ContactMethodType.find(:all).length, "Number of ContactMethodTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
    contact_method_type_count = ContactMethodType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal contact_method_type_count - 1, ContactMethodType.find(:all).length, "Number of ContactMethodTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
    contact_method_type_count = ContactMethodType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_method_type_count - 1, ContactMethodType.find(:all).length, "Number of ContactMethodTypes should be one less"
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
