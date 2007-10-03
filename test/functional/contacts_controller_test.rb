require File.dirname(__FILE__) + '/../test_helper'
require 'contacts_controller'

# Re-raise errors caught by the controller.
class ContactsController; def rescue_action(e) raise e end; end

class ContactsControllerTest < Test::Unit::TestCase
  fixtures :contacts

  NEW_CONTACT = {
    'postal_code' => '98982',
    'surname' => 'Foo',
    'first_name' => 'Ninja'
  }
  NEW_CONTACT_TYPES = []

  def setup
    @controller = ContactsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = contacts(:first)
    @first = Contact.find(:first)
  end

  def test_cancel_xhr
    xhr :post, :cancel
    assert_response :success
    assert_rjs :remove,"floating_form"
  end
  
  def test_new_xhr
    xhr :post, :new
    assert_response :success
    assert_rjs :insert_html, :bottom, 'content'
    assert_rjs :hide, "loading_indicator_id"
    assert_rjs :replace_html, "search_results_id", ''
  end

  def test_that_searching_by_id_works
    someone = Contact.find(:first)
    xhr :post, :search_results, {:contact_query => someone.id.to_s}
    assert_response :success
    assert_template '_search_results'
    assert_equal someone, assigns(:search_results)[0]
    assert_equal 1, assigns(:search_results).length
  end

  def test_that_searching_by_name_works
    someone = Contact.find(:first)
    contacts = Contact.find(:all, :conditions => ["surname = ?", someone.surname], :limit => 5)
    assert contacts.length <= 5
    assert contacts.length >= 1
    xhr :post, :search_results, {:contact_query => someone.surname.to_s}
    assert_response :success
    assert_template '_search_results'
    if contacts.length == 5
      assert false, "too many results to be sure..."
    else
      assert_equal contacts.length, assigns(:search_results).length, "#{contacts.to_yaml} != #{assigns(:search_results).to_yaml}"
      assert assigns(:search_results).include?(someone), "someone isn't in the results"
    end
  end

  def test_that_searching_by_multiple_fields_works
    someone = Contact.find(:first)
    contacts = Contact.find(:all, :conditions => ["surname = ? AND first_name = ?", someone.surname, someone.first_name], :limit => 5)
    assert contacts.length <= 5
    assert contacts.length >= 1
    xhr :post, :search_results, {:contact_query => "%s %s"%[someone.surname.to_s, someone.first_name.to_s]}
    assert_response :success
    assert_template '_search_results'
    if contacts.length == 5
      assert false, "too many results to be sure..."
    else
      assert_equal contacts.length, assigns(:search_results).length, "#{contacts.to_yaml} != #{assigns(:search_results).to_yaml}"
      assert assigns(:search_results).include?(someone), "someone isn't in the results"
    end
  end

  def test_that_searching_for_nothing_fails
    xhr :post, :search_results, {:contact_query => ""}
    assert_response :success
    assert_template '_search_results'
    assert_equal 0, assigns(:search_results).length
  end


  def test_create_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :create, {:contact => NEW_CONTACT }
    contact, successful = check_attrs(%w(contact successful))
    assert assigns(:successful), "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal contact_count + 1, Contact.find(:all).length, "Expected an additional Contact"
    assert_rjs :remove, 'floating_form'
  end

  def test_update_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :update, {:id => @first.id, :contact => @first.attributes.merge(NEW_CONTACT), :contact_types => NEW_CONTACT_TYPES}
    contact, successful = check_attrs(%w(contact successful))
#    assert successful, "Should be successful"
    contact.reload
     NEW_CONTACT.each do |attr_name|
      assert_equal NEW_CONTACT[attr_name], contact.attributes[attr_name], "@contact.#{attr_name.to_s} incorrect"
    end
    assert_equal contact_count, Contact.find(:all).length, "Number of Contacts should be the same"
    assert_response :success
    assert_template 'update.rjs'
    assert_rjs :remove, 'floating_form'
  end

  def test_destroy_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_count - 1, Contact.find(:all).length, "Number of Contacts should be one less"
    assert_template 'destroy.rjs'
  end

  def test_update_display_area
    xhr :post, :update_display_area, {:contact_id => @first.id}
    assert_response :success
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
