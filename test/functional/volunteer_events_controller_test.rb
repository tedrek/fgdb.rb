require 'test_helper'

class VolunteerEventsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:volunteer_events)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_volunteer_event
    assert_difference('VolunteerEvent.count') do
      post :create, :volunteer_event => { }
    end

    assert_redirected_to volunteer_event_path(assigns(:volunteer_event))
  end

  def test_should_show_volunteer_event
    get :show, :id => volunteer_events(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => volunteer_events(:one).id
    assert_response :success
  end

  def test_should_update_volunteer_event
    put :update, :id => volunteer_events(:one).id, :volunteer_event => { }
    assert_redirected_to volunteer_event_path(assigns(:volunteer_event))
  end

  def test_should_destroy_volunteer_event
    assert_difference('VolunteerEvent.count', -1) do
      delete :destroy, :id => volunteer_events(:one).id
    end

    assert_redirected_to volunteer_events_path
  end
end
