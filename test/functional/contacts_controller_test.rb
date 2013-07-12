require File.dirname(__FILE__) + '/../test_helper'

# Re-raise errors caught by the controller.
class ContactsController; def rescue_action(e) raise e end; end

class ContactsControllerTest < ActionController::TestCase
  fixtures :contacts, :users, :roles_users

  NEW_CONTACT = {:first_name=>"Joe", :middle_name=>'', :surname=> 'Strummer',
    :organization=>'a', :extra_address=>'', :address=>'Elsewhere',
    :city=>'London', :state_or_province=>'UK', :postal_code=>'123',
    :country=>'Britain', :notes=>'', :created_by=>1}
  NEW_CONTACT_TYPES = []

  def setup
    @controller = ContactsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = Contact.find(:first)
  end

  def test_arbitrary_auto_complete_calls
    login_as :quentin
    post(:auto_complete_for_filter_contact_query,
         'filter_contact' => {'query' => 'foo'},
         "object_name" => 'filter_contact',
         :field_name => 'query'
         )
    assert_response :success
    assert_template '_auto_complete_list'
  end

  def test_lookup
    login_as :quentin
    get :lookup
    assert_response :success
    assert_template 'lookup'
  end

  def test_new_xhr
    login_as :quentin
    xhr :post, :new
    assert_response :success
    assert_template '_new_edit'
    assert_match /Form.disable/, @response.body
  end

  def test_create_xhr
    login_as :quentin
    contact_count = Contact.find(:all).length
    xhr :post, :create, {:contact => NEW_CONTACT}
    assert_response :success
    assert assigns(:contact)
    assert assigns(:successful)
    assert_template 'create.rjs'
    assert_equal contact_count + 1, Contact.find(:all).length, "Expected an additional Contact"
    contact, successful = check_attrs(%w(contact successful))
    assert contact.id, "Should have a contact id"
  end

  def test_create_xhr_invalid
    login_as :quentin
    xhr :post, :create, {:contact => { }}
    contact, successful = check_attrs(%w(contact successful))
    assert_response :success
    assert_template 'create.rjs'
    assert ! successful, "Should not be successful"
    assert_match /First name or surname must be provided for individuals/i, @response.body
    assert_match /Form.enable/, @response.body
    assert_match /addClassName[^;]+fieldWithErrors/, @response.body
  end

  def test_update_xhr
    login_as :quentin
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
    login_as :quentin
    contact_count = Contact.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal contact_count - 1, Contact.find(:all).length, "Number of Contacts should be one less"
    assert_template 'destroy.rjs'
  end

  def test_cancel_xhr
    login_as :quentin
    xhr :get, :cancel
    assert_response :success
    assert_template 'cancel.rjs'
    assert assigns(:successful)
    assert_rjs :remove, 'floating_form'
    assert_match /^Form.enable\(\$\('\w*contact_id'\)/, @response.body
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

  def test_create_with_roles
    login_as :quentin
    post :create, "roles"=>["2", "3", "5"], "user"=>{"password_confirmation"=>"secret", "login"=>"foo", "password"=>"secret", "email"=>"foo@default.com"}, "commit"=>"Create", "contact"=>{"city"=>"Portland", "is_user"=>"1", "is_organization"=>"0", "state_or_province"=>"OR", "postal_code"=>"97232", "country"=>"United States", "extra_address"=>"", "notes"=>"", "organization"=>"", "first_name"=>"martin", "surname"=>"chase", "address"=>"", "middle_name"=>""}, "action"=>"create", "controller"=>"contacts", "contact_types"=>["7", "4", "12", "13"], "datalist_new"=>{"contacts_contact_methods"=>{}}, "datalist_contacts_contact_methods_id"=>"datalist-contacts_contact_methods-table"
    assert_response :success
    contact = assigns(:contact)
    assert_kind_of Contact, contact
    assert contact.save
    contact = Contact.find(contact.id)
    [2, 3, 5].each {|role_id|
      assert contact.user.roles.map {|role| role.id.to_i}.include?(role_id), "roles should include #{role_id}"
    }
  end
end
