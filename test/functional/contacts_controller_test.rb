require File.dirname(__FILE__) + '/../test_helper'
require 'contacts_controller'

# Re-raise errors caught by the controller.
class ContactsController; def rescue_action(e) raise e end; end

class ContactsControllerTest < Test::Unit::TestCase
  fixtures :contacts

  NEW_CONTACT = {}  # e.g. {:name => 'Test Contact', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = ContactsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = contacts(:first)
    @first = Contact.find_first
  end

  def test_component
    get :component
    assert_response :success
    assert_template 'contacts/component'
    contacts = check_attrs(%w(contacts))
    assert_equal Contact.find(:all).length, contacts.length, "Incorrect number of contacts shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'contacts/component'
    contacts = check_attrs(%w(contacts))
    assert_equal Contact.find(:all).length, contacts.length, "Incorrect number of contacts shown"
  end

  def test_create
    contact_count = Contact.find(:all).length
    post :create, {:contact => NEW_CONTACT}
    contact, successful = check_attrs(%w(contact successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal contact_count + 1, Contact.find(:all).length, "Expected an additional Contact"
  end

  def test_create_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :create, {:contact => NEW_CONTACT}
    contact, successful = check_attrs(%w(contact successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal contact_count + 1, Contact.find(:all).length, "Expected an additional Contact"
  end

  def test_update
    contact_count = Contact.find(:all).length
    post :update, {:id => @first.id, :contact => @first.attributes.merge(NEW_CONTACT)}
    contact, successful = check_attrs(%w(contact successful))
    assert successful, "Should be successful"
    contact.reload
     NEW_CONTACT.each do |attr_name|
      assert_equal NEW_CONTACT[attr_name], contact.attributes[attr_name], "@contact.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_count, Contact.find(:all).length, "Number of Contacts should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :update, {:id => @first.id, :contact => @first.attributes.merge(NEW_CONTACT)}
    contact, successful = check_attrs(%w(contact successful))
    assert successful, "Should be successful"
    contact.reload
     NEW_CONTACT.each do |attr_name|
      assert_equal NEW_CONTACT[attr_name], contact.attributes[attr_name], "@contact.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_count, Contact.find(:all).length, "Number of Contacts should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
    contact_count = Contact.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal contact_count - 1, Contact.find(:all).length, "Number of Contacts should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_count - 1, Contact.find(:all).length, "Number of Contacts should be one less"
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
