require File.dirname(__FILE__) + '/../test_helper'
require 'contact_types_controller'

# Re-raise errors caught by the controller.
class ContactTypesController; def rescue_action(e) raise e end; end

class ContactTypesControllerTest < Test::Unit::TestCase
  fixtures :contact_types

	NEW_CONTACT_TYPE = {}	# e.g. {:name => 'Test ContactType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = ContactTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = contact_types(:first)
		@first = ContactType.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'contact_types/component'
    contact_types = check_attrs(%w(contact_types))
    assert_equal ContactType.find(:all).length, contact_types.length, "Incorrect number of contact_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'contact_types/component'
    contact_types = check_attrs(%w(contact_types))
    assert_equal ContactType.find(:all).length, contact_types.length, "Incorrect number of contact_types shown"
  end

  def test_create
  	contact_type_count = ContactType.find(:all).length
    post :create, {:contact_type => NEW_CONTACT_TYPE}
    contact_type, successful = check_attrs(%w(contact_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal contact_type_count + 1, ContactType.find(:all).length, "Expected an additional ContactType"
  end

  def test_create_xhr
  	contact_type_count = ContactType.find(:all).length
    xhr :post, :create, {:contact_type => NEW_CONTACT_TYPE}
    contact_type, successful = check_attrs(%w(contact_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal contact_type_count + 1, ContactType.find(:all).length, "Expected an additional ContactType"
  end

  def test_update
  	contact_type_count = ContactType.find(:all).length
    post :update, {:id => @first.id, :contact_type => @first.attributes.merge(NEW_CONTACT_TYPE)}
    contact_type, successful = check_attrs(%w(contact_type successful))
    assert successful, "Should be successful"
    contact_type.reload
   	NEW_CONTACT_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_TYPE[attr_name], contact_type.attributes[attr_name], "@contact_type.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_type_count, ContactType.find(:all).length, "Number of ContactTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	contact_type_count = ContactType.find(:all).length
    xhr :post, :update, {:id => @first.id, :contact_type => @first.attributes.merge(NEW_CONTACT_TYPE)}
    contact_type, successful = check_attrs(%w(contact_type successful))
    assert successful, "Should be successful"
    contact_type.reload
   	NEW_CONTACT_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_TYPE[attr_name], contact_type.attributes[attr_name], "@contact_type.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_type_count, ContactType.find(:all).length, "Number of ContactTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	contact_type_count = ContactType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal contact_type_count - 1, ContactType.find(:all).length, "Number of ContactTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	contact_type_count = ContactType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_type_count - 1, ContactType.find(:all).length, "Number of ContactTypes should be one less"
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
