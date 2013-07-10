require 'test_helper'

class SystemPricingsControllerTest < ActionController::TestCase
  fixtures :roles, :roles_users, :users
  def setup
    login_as :quentin
  end

  fixtures :pricing_types, :system_pricings

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:system_pricings)
  end

  def test_should_create_system_pricing
    assert_difference('SystemPricing.count') do
      post :create, :system_pricing => {
        :magic_bit => 1,
        :pricing_type => PricingType.find(:first)
      }
    end

    assert_response :redirect
  end

  def test_should_show_system_pricing
    get :show, :id => system_pricings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => system_pricings(:one).id
    assert_response :success
  end

  def test_should_update_system_pricing
    put :update, :id => system_pricings(:one).id, :system_pricing => { }
    assert_response :redirect
  end

  def test_should_destroy_system_pricing
    assert_difference('SystemPricing.count', -1) do
      delete :destroy, :id => system_pricings(:one).id
    end

    assert_response :redirect
  end
end
