require File.dirname(__FILE__) + '/../test_helper'

class DonationsControllerTest < ActionController::TestCase
  fixtures :payment_methods, :users, :roles, :roles_users, :gizmo_types, :gizmo_contexts, :contacts

  def create_a_new_donation
    d = Donation.new({:contact_type => 'anonymous', :postal_code => '12435'})
    d.gizmo_events = [GizmoEvent.new(donated_system_event)]
    assert d.save
    return d
  end

  def test_basic_unauthorized_actions_redirect
    get :index
    assert :redirect
  end

  def test_basic_authorized_actions_succeed
    login_as :quentin
    get :index
    assert :success
  end

  def test_specific_unauthorized_actions_redirect
    donation = create_a_new_donation
    assert donation.id
    get :index
    get :destroy, :id => donation.id, :scaffold_id => 'donations'
    assert_nothing_raised("donation shouldn't have been deleted") {Donation.find(donation.id)}
    assert_response :redirect
  end

  def test_specific_authorized_actions_succeed
    [:quentin, :aaron].each { |user|
      login_as user
      donation = create_a_new_donation
      get :index
      get :destroy, :id => donation.id, :scaffold_id => 'donations'
      assert_raises(ActiveRecord::RecordNotFound) { Donation.find(donation.id) }
    }
  end

  def test_userstamp
    donation = nil
    assert_raises(ActiveRecord::StatementInvalid) {
      donation = create_a_new_donation
    }

    q = users(:quentin)
    assert q
    login_as :quentin
    donation = create_a_new_donation
    assert_equal q, donation.created_by
    assert !donation.updated_by

    donation.postal_code = "zzz"
    donation.save
    assert_equal q, donation.created_by
    assert_equal q, donation.updated_by
  end

  def test_a_donation_with_a_contact
    contact = Contact.find(:first)
    login_as :quentin

    post :create, { "commit"=>"Create",
      "datalist_donation_payments_id"=>"datalist-donation_payments-table",
      "contact_element_prefix"=>"contact", "contact"=>{
        "query"=>contact.id
      },
      "action"=>"create",
      "transaction_type"=>"donation", "id"=>"1205620388344",
      "datalist_donation_gizmo_events_id"=>"datalist-donation_gizmo_events-table",
      "controller"=>"donations",
      "donation"=>{
        "postal_code"=>"",
        "comments"=>"", "contact_id"=>contact.id,
        "contact_type"=>"named"
      },
      "datalist_new"=>{
        "donation_gizmo_events"=>{
          "1205620388434"=>{
            "gizmo_count"=>"1",
            "description"=>"",
            "gizmo_type_id"=>"4",
            "gizmo_context_id"=>"1"
          }
        },
        "donation_payments"=>{
          "1205620388373"=>{
            "payment_method_id"=>"",
            "amount"=>"0.0"
          }
        }
      }
    }
    assert_response :success
  end
end
