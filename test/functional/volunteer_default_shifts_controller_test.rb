require 'test_helper'

class VolunteerDefaultShiftsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:volunteer_default_shifts)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_volunteer_default_shift
    assert_difference('VolunteerDefaultShift.count') do
      post :create, :volunteer_default_shift => { }
    end

    assert_redirected_to volunteer_default_shift_path(assigns(:volunteer_default_shift))
  end

  def test_should_show_volunteer_default_shift
    get :show, :id => volunteer_default_shifts(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => volunteer_default_shifts(:one).id
    assert_response :success
  end

  def test_should_update_volunteer_default_shift
    put :update, :id => volunteer_default_shifts(:one).id, :volunteer_default_shift => { }
    assert_redirected_to volunteer_default_shift_path(assigns(:volunteer_default_shift))
  end

  def test_should_destroy_volunteer_default_shift
    assert_difference('VolunteerDefaultShift.count', -1) do
      delete :destroy, :id => volunteer_default_shifts(:one).id
    end

    assert_redirected_to volunteer_default_shifts_path
  end
end
