require 'test_helper'

class PricingTypesControllerTest < ActionController::TestCase
  fixtures :roles, :roles_users, :users
  def setup
    login_as :quentin
  end

  fixtures :pricing_types

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
      post :create, :pricing_type => {
        :name => "Test pricing type"
      }
    end

    assert_response :redirect
  end

  def test_should_get_edit
    get :edit, :id => pricing_types(:one).id
    assert_response :success
  end

  def test_should_update_pricing_type
    put :update, :id => pricing_types(:one).id, :pricing_type => { }
    assert_response :redirect
  end

  def test_should_destroy_pricing_type
    assert_difference('PricingType.count', 0) do
      delete :destroy, :id => pricing_types(:one).id
    end

    assert_response :redirect
  end
end
