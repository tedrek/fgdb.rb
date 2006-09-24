require File.dirname(__FILE__) + '/../test_helper'
require 'donations_controller'

# Re-raise errors caught by the controller.
class DonationsController; def rescue_action(e) raise e end; end

class DonationsControllerTest < Test::Unit::TestCase
  fixtures :donations

	NEW_DONATION = {}	# e.g. {:name => 'Test Donation', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DonationsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = donations(:first)
		@first = Donation.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'donations/component'
    donations = check_attrs(%w(donations))
    assert_equal Donation.find(:all).length, donations.length, "Incorrect number of donations shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'donations/component'
    donations = check_attrs(%w(donations))
    assert_equal Donation.find(:all).length, donations.length, "Incorrect number of donations shown"
  end

  def test_create
  	donation_count = Donation.find(:all).length
    post :create, {:donation => NEW_DONATION}
    donation, successful = check_attrs(%w(donation successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal donation_count + 1, Donation.find(:all).length, "Expected an additional Donation"
  end

  def test_create_xhr
  	donation_count = Donation.find(:all).length
    xhr :post, :create, {:donation => NEW_DONATION}
    donation, successful = check_attrs(%w(donation successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal donation_count + 1, Donation.find(:all).length, "Expected an additional Donation"
  end

  def test_update
  	donation_count = Donation.find(:all).length
    post :update, {:id => @first.id, :donation => @first.attributes.merge(NEW_DONATION)}
    donation, successful = check_attrs(%w(donation successful))
    assert successful, "Should be successful"
    donation.reload
   	NEW_DONATION.each do |attr_name|
      assert_equal NEW_DONATION[attr_name], donation.attributes[attr_name], "@donation.#{attr_name.to_s} incorrect"
    end
    assert_equal donation_count, Donation.find(:all).length, "Number of Donations should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	donation_count = Donation.find(:all).length
    xhr :post, :update, {:id => @first.id, :donation => @first.attributes.merge(NEW_DONATION)}
    donation, successful = check_attrs(%w(donation successful))
    assert successful, "Should be successful"
    donation.reload
   	NEW_DONATION.each do |attr_name|
      assert_equal NEW_DONATION[attr_name], donation.attributes[attr_name], "@donation.#{attr_name.to_s} incorrect"
    end
    assert_equal donation_count, Donation.find(:all).length, "Number of Donations should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	donation_count = Donation.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal donation_count - 1, Donation.find(:all).length, "Number of Donations should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	donation_count = Donation.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal donation_count - 1, Donation.find(:all).length, "Number of Donations should be one less"
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
