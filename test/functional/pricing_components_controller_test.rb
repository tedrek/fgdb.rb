require 'test_helper'

class PricingComponentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pricing_components)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pricing_component
    assert_difference('PricingComponent.count') do
      post :create, :pricing_component => { }
    end

    assert_redirected_to pricing_component_path(assigns(:pricing_component))
  end

  def test_should_show_pricing_component
    get :show, :id => pricing_components(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pricing_components(:one).id
    assert_response :success
  end

  def test_should_update_pricing_component
    put :update, :id => pricing_components(:one).id, :pricing_component => { }
    assert_redirected_to pricing_component_path(assigns(:pricing_component))
  end

  def test_should_destroy_pricing_component
    assert_difference('PricingComponent.count', -1) do
      delete :destroy, :id => pricing_components(:one).id
    end

    assert_redirected_to pricing_components_path
  end
end
