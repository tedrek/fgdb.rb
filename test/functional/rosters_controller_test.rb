require 'test_helper'

class RostersControllerTest < ActionController::TestCase
  fixtures :users, :roles_users, :roles
  def setup
    login_as :quentin
  end

  fixtures :rosters

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:rosters)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_roster
    assert_difference('Roster.count') do
      post :create, :roster => { }
    end

    assert_response :redirect
  end

  def test_should_show_roster
    get :show, :id => rosters(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => rosters(:one).id
    assert_response :success
  end

  def test_should_update_roster
    put :update, :id => rosters(:one).id, :roster => { }
    assert_response :redirect
  end

  def test_should_destroy_roster
    assert_difference('Roster.count', -1) do
      delete :destroy, :id => rosters(:one).id
    end

    assert_response :redirect
  end
end
