require File.dirname(__FILE__) + '/../test_helper'

class SystemsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:systems)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_system
    assert_difference('System.count') do
      post :create, :system => { }
    end

    assert_redirected_to system_path(assigns(:system))
  end

  def test_should_show_system
    get :show, :id => systems(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => systems(:one).id
    assert_response :success
  end

  def test_should_update_system
    put :update, :id => systems(:one).id, :system => { }
    assert_redirected_to system_path(assigns(:system))
  end

  def test_should_destroy_system
    assert_difference('System.count', -1) do
      delete :destroy, :id => systems(:one).id
    end

    assert_redirected_to systems_path
  end
end
