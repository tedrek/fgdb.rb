require File.dirname(__FILE__) + '/../test_helper'
require 'transaction_controller'

# Re-raise errors caught by the controller.
class TransactionController; def rescue_action(e) raise e end; end

class TransactionControllerTest < Test::Unit::TestCase
  fixtures :discount_schedules, :payment_methods, :users, :roles, :roles_users

  def create_a_new_donation
    d = Donation.new({:contact_type => 'anonymous', :postal_code => '12435'})
    d.gizmo_events = [GizmoEvent.new(system_event)]
    d.save
    return d
  end

  def setup
    @controller = TransactionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_basic_unauthorized_actions_redirect
    get :sales
    assert :redirect
    get :donations
    assert :redirect
    get :disbursements
    assert :success
    get :recycling
    assert :success
  end

  def test_basic_authorized_actions_succeed
    login_as :quentin
    get :sales
    assert :success
    get :donations
    assert :success
    get :disbursements
    assert :success
    get :recycling
    assert :success
  end

end
