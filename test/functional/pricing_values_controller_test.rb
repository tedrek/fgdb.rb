require 'test_helper'

class PricingValuesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pricing_values)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pricing_value
    assert_difference('PricingValue.count') do
      post :create, :pricing_value => { }
    end

    assert_redirected_to pricing_value_path(assigns(:pricing_value))
  end

  def test_should_show_pricing_value
    get :show, :id => pricing_values(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pricing_values(:one).id
    assert_response :success
  end

  def test_should_update_pricing_value
    put :update, :id => pricing_values(:one).id, :pricing_value => { }
    assert_redirected_to pricing_value_path(assigns(:pricing_value))
  end

  def test_should_destroy_pricing_value
    assert_difference('PricingValue.count', -1) do
      delete :destroy, :id => pricing_values(:one).id
    end

    assert_redirected_to pricing_values_path
  end
end
