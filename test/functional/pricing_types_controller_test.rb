require 'test_helper'

class PricingTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:pricing_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_pricing_type
    assert_difference('PricingType.count') do
      post :create, :pricing_type => { }
    end

    assert_redirected_to pricing_type_path(assigns(:pricing_type))
  end

  def test_should_show_pricing_type
    get :show, :id => pricing_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => pricing_types(:one).id
    assert_response :success
  end

  def test_should_update_pricing_type
    put :update, :id => pricing_types(:one).id, :pricing_type => { }
    assert_redirected_to pricing_type_path(assigns(:pricing_type))
  end

  def test_should_destroy_pricing_type
    assert_difference('PricingType.count', -1) do
      delete :destroy, :id => pricing_types(:one).id
    end

    assert_redirected_to pricing_types_path
  end
end
