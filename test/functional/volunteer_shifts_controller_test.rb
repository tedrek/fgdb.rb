require 'test_helper'

class VolunteerShiftsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:volunteer_shifts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_volunteer_shift
    assert_difference('VolunteerShift.count') do
      post :create, :volunteer_shift => { }
    end

    assert_redirected_to volunteer_shift_path(assigns(:volunteer_shift))
  end

  def test_should_show_volunteer_shift
    get :show, :id => volunteer_shifts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => volunteer_shifts(:one).id
    assert_response :success
  end

  def test_should_update_volunteer_shift
    put :update, :id => volunteer_shifts(:one).id, :volunteer_shift => { }
    assert_redirected_to volunteer_shift_path(assigns(:volunteer_shift))
  end

  def test_should_destroy_volunteer_shift
    assert_difference('VolunteerShift.count', -1) do
      delete :destroy, :id => volunteer_shifts(:one).id
    end

    assert_redirected_to volunteer_shifts_path
  end
end
