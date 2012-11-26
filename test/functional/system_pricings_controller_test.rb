require 'test_helper'

class SystemPricingsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:system_pricings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_system_pricing
    assert_difference('SystemPricing.count') do
      post :create, :system_pricing => { }
    end

    assert_redirected_to system_pricing_path(assigns(:system_pricing))
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
    assert_redirected_to system_pricing_path(assigns(:system_pricing))
  end

  def test_should_destroy_system_pricing
    assert_difference('SystemPricing.count', -1) do
      delete :destroy, :id => system_pricings(:one).id
    end

    assert_redirected_to system_pricings_path
  end
end
