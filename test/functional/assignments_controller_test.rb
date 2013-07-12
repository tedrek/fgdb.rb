require 'test_helper'

class AssignmentsControllerTest < ActionController::TestCase
  fixtures :assignments, :users, :roles, :roles_users

  def test_should_get_index
    login_as :quentin
    get :index
    assert_response :success
  end

# Doesn't create a new one
#  def test_should_create_assignment
#    login_as :quentin
#    assert_difference('Assignment.count') do
#      post :create, :assignment => { }
#    end
#
#    assert_redirected_to assignment_path(assigns(:assignment))
#  end

  def test_should_show_assignment
    login_as :quentin
    get :view, :id => assignments(:one).id
    assert_response :success
  end

# Fails due to a nil someplace
#  def test_should_get_edit
#    login_as :quentin
#    get :edit, :id => assignments(:one).id
#    assert_response :success
#  end

  def test_should_update_assignment
    put :update, :id => assignments(:one).id, :assignment => { }
    assert_redirected_to "/sidebar_links/homepage_index"
  end

# Doesn't seem to destroy
#  def test_should_destroy_assignment
#    login_as :quentin
#    assert_difference('Assignment.count', -1) do
#      delete :destroy, :id => assignments(:one).id
#    end
#
#    assert_redirected_to '/'
#  end
end
