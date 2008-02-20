require File.dirname(__FILE__) + '/../test_helper'
require 'contacts_controller'

# Re-raise errors caught by the controller.
class ContactsController; def rescue_action(e) raise e end; end

class ContactsControllerTest < Test::Unit::TestCase
  fixtures :contacts, :volunteer_task_types, :discount_schedules

  NEW_CONTACT = {
    'postal_code' => '98982'
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

  def test_lookup
    get :lookup
    assert_response :success
    assert_template 'lookup'
  end

  def test_search_results
    martin = Contact.new({ :first_name => 'martin', :postal_code => 'meow' })
    assert martin.save
    assert_nothing_raised { martin.adoption_hours }
    xhr :post, :search_results, :contact_query => 'martin'
    assert_response :success
    assert_template '_search_results'
  end

  def test_search_results_with_on_display
    on_display_js = "alert('test');"
    martin = Contact.new({ :first_name => 'martin', :postal_code => 'meow' })
    martin.save
    assert_nothing_raised { martin.adoption_hours }
    xhr :post, :search_results, :options => {:on_display => on_display_js}, :contact_query => 'martin'
    assert_response :success
    assert_template '_search_results'
    assert_match on_display_js, @response.body
  end

  def test_new_xhr
    xhr :post, :new
    assert_response :success
    assert_template 'new.rjs'
    assert_match /Form.disable/, @response.body
  end

  def test_create_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :create, {:contact => NEW_CONTACT}
    assert_response :success
    assert_template 'create.rjs'
    assert_equal contact_count + 1, Contact.find(:all).length, "Expected an additional Contact"
    contact, successful = check_attrs(%w(contact successful))
    assert contact.id, "Should have a contact id"
  end

  def test_create_xhr_invalid
    xhr :post, :create, {:contact => { }}
    contact, successful = check_attrs(%w(contact successful))
    assert_response :success
    assert_template 'create.rjs'
    assert ! successful, "Should not be successful"
    assert_match /Postal code can't be blank/i, @response.body
    assert_match /Form.enable/, @response.body
    assert_match /addClassName[^;]+fieldWithErrors/, @response.body
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
  end

  def test_destroy_xhr
    contact_count = Contact.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_count - 1, Contact.find(:all).length, "Number of Contacts should be one less"
    assert_template 'destroy.rjs'
  end

  def test_cancel_xhr
    xhr :get, :cancel
    assert_response :success
    assert_template 'cancel.rjs'
    assert assigns(:successful)
    assert_rjs :remove, 'floating_form'
    assert_match /^Form.enable\(\$\('\w*contact_query'\)/, @response.body
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
