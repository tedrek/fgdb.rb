require 'test_helper'

class PricingValuesControllerTest < ActionController::TestCase
  fixtures :roles, :roles_users, :users
  def setup
    login_as :quentin
  end

  fixtures :pricing_components, :pricing_values

  def test_should_get_new
    get :new, :pricing_component_id => pricing_components(:one).id
    assert_response :success
  end

  def test_should_create_pricing_value
    assert_difference('PricingValue.count') do
      post(:create,
           :pricing_component_id => pricing_components(:one).id,
           :pricing_value => {
             :name => "Test pricing value",
             :value_cents => 1,
           })
    end

    assert_response :redirect
  end

  def test_should_get_edit
    get :edit, :id => pricing_values(:one).id
    assert_response :success
  end

  def test_should_update_pricing_value
    put :update, :id => pricing_values(:one).id, :pricing_value => { }
    assert_response :redirect
  end

  def test_should_destroy_pricing_value
    assert_difference('PricingValue.count', 0) do
      delete :destroy, :id => pricing_values(:one).id
    end

    assert_response :redirect
  end
end
