require 'test_helper'

class GizmoTypeGroupsControllerTest < ActionController::TestCase
  fixtures :gizmo_type_groups, :users, :roles_users, :roles

  def setup
    login_as :quentin
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gizmo_type_groups)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gizmo_type_group" do
    assert_difference('GizmoTypeGroup.count') do
      post :create, :gizmo_type_group => { }
    end

    assert_redirected_to gizmo_type_group_path(assigns(:gizmo_type_group))
  end

  test "should show gizmo_type_group" do
    get :show, :id => gizmo_type_groups(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => gizmo_type_groups(:one).to_param
    assert_response :success
  end

  test "should update gizmo_type_group" do
    put :update, :id => gizmo_type_groups(:one).to_param, :gizmo_type_group => { }
    assert_redirected_to gizmo_type_group_path(assigns(:gizmo_type_group))
  end

  test "should destroy gizmo_type_group" do
    assert_difference('GizmoTypeGroup.count', -1) do
      delete :destroy, :id => gizmo_type_groups(:one).to_param
    end

    assert_redirected_to gizmo_type_groups_path
  end
end
