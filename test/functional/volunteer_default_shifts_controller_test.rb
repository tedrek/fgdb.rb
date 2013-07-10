require 'test_helper'

class VolunteerDefaultShiftsControllerTest < ActionController::TestCase
  fixtures :roles, :roles_users, :users
  def setup
    login_as :quentin
  end

  fixtures :volunteer_default_events, :volunteer_default_shifts

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => volunteer_default_shifts(:one).id
    assert_response :redirect
  end

  def test_should_destroy_volunteer_default_shift
    assert_difference('VolunteerDefaultShift.count', -1) do
      delete :destroy, :id => volunteer_default_shifts(:one).id
    end

    assert_response :redirect
  end
end
