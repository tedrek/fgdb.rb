require File.dirname(__FILE__) + '/../test_helper'

class DonationsControllerTest < ActionController::TestCase
  fixtures :discount_schedules, :payment_methods, :users, :roles, :roles_users, :gizmo_types, :gizmo_contexts

  def create_a_new_donation
    d = Donation.new({:contact_type => 'anonymous', :postal_code => '12435'})
    d.gizmo_events = [GizmoEvent.new(system_event)]
    assert d.save
    return d
  end

  def test_basic_unauthorized_actions_redirect
    get :donations
    assert :redirect
  end

  def test_basic_authorized_actions_succeed
    login_as :quentin
    get :donations
    assert :success
  end

  def test_specific_unauthorized_actions_redirect
    donation = create_a_new_donation
    assert donation.id
    get :donations
    get :destroy, :id => donation.id, :scaffold_id => 'donations'
    assert_nothing_raised("donation shouldn't have been deleted") {Donation.find(donation.id)}
    assert_response :redirect
  end

  def test_specific_authorized_actions_succeed
    [:quentin, :aaron].each { |user|
      login_as user
      donation = create_a_new_donation
      get :donations
      get :destroy, :id => donation.id, :scaffold_id => 'donations'
      assert_raises(ActiveRecord::RecordNotFound) { Donation.find(donation.id) }
      assert_response :success
    }
  end

end
