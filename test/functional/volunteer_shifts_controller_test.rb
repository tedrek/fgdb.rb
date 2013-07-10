require 'test_helper'

class VolunteerShiftsControllerTest < ActionController::TestCase
  fixtures :roles, :roles_users, :users
  def setup
    login_as :quentin
  end

  fixtures :volunteer_events, :volunteer_shifts

  def test_should_get_index
    get :index
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => volunteer_shifts(:one).id
    assert_response :redirect
  end

  def test_should_destroy_volunteer_shift
    assert_difference('VolunteerShift.count', -1) do
      delete :destroy, :id => volunteer_shifts(:one).id
    end

    assert_response :redirect
  end
end
