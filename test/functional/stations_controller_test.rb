require 'test_helper'

class StationsControllerTest < ActionController::TestCase
  fixtures :users, :roles_users

  setup do
    login_as :quentin
    @station = VolunteerTaskType.first()
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create station" do
    assert_difference('VolunteerTaskType.count') do
      post :create, :volunteer_task_type => @station.attributes
    end

    assert_redirected_to volunteer_task_type_path(assigns(:station))
  end

  test "should show station" do
    get :show, :id => @station.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @station.to_param
    assert_response :success
  end

  test "should update station" do
    put :update, :id => @station.to_param, :station => @station.attributes
    assert_redirected_to volunteer_task_type_path(assigns(:station))
  end
end
