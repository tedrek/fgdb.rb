require File.dirname(__FILE__) + '/../test_helper'

class SalesControllerTest < ActionController::TestCase
  load_all_fixtures()
  #fixtures(:gizmo_contexts_gizmo_typeattrs)
  def cash_payment(amt)
    pmt = Payment.new
    pmt.amount = amt
    pmt.payment_method_id = 1
    return pmt
  end

  def create_a_new_sale
    s = Sale.new({:contact_type => 'named', 
                   :created_by => 1, 
                   :discount_percentage =>
                   DiscountPercentage.find(:first,
                                           :conditions => "percentage = 0"),
                   :discount_name => 
                   DiscountName.find(:first,
                                     :conditions => "description = 'None'")})
    s.contact = Contact.find(:first)
    s.gizmo_events = [GizmoEvent.new(sold_system_event)]
    s.gizmo_events[0].unit_price = "20"
    s.payments = [cash_payment("20")]
    s.save
    return s
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
    sale = create_a_new_sale
    get :index
    get :destroy, :id => sale.id, :scaffold_id => 'sales'
    assert Sale.find(sale.id)
    assert_response :redirect
  end

  def test_specific_authorized_actions_succeed
    login_as :quentin
    sale = create_a_new_sale
    sale = Sale.find(sale.id)
    assert_equal "20.00", sale.gizmo_events[0].unit_price
    get :index
    get :destroy, :id => sale.id, :scaffold_id => 'sales'
    assert_raises(ActiveRecord::RecordNotFound) { Sale.find(sale.id) }
  end

  def test_filter_by_date
    login_as :quentin
    date = "2007-02-20"
    post :component_update, { "commit"=>"Refine", "conditions"=>{ "created_at_month"=>"2", "created_at_start_date"=>"", "created_at_end_date"=>"", "created_at_date"=>date, "created_at_date_type"=>"daily", "payment_method_id"=>"1", "created_at_year"=>"2008", "created_at_enabled" => "true"}, "action"=>"component_update", "controller"=>"sales", "scaffold_id"=>"sale"}
    assert_response :success
    conditions = assigns(:conditions)
    assert_equal date, conditions.created_at_date
  end
end
