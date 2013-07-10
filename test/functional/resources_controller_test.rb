require 'test_helper'

class ResourcesControllerTest < ActionController::TestCase
  fixtures :users, :roles_users, :roles
  def setup
    login_as :quentin
  end

  fixtures :resources

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:resources)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_resource
    assert_difference('Resource.count') do
      post :create, :resource => { }
    end

    assert_response :redirect
  end

  def test_should_show_resource
    get :show, :id => resources(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => resources(:one).id
    assert_response :success
  end

  def test_should_update_resource
    put :update, :id => resources(:one).id, :resource => { }
    assert_response :redirect
  end

  def test_should_destroy_resource
    assert_difference('Resource.count', -1) do
      delete :destroy, :id => resources(:one).id
    end

    assert_response :redirect
  end
end
