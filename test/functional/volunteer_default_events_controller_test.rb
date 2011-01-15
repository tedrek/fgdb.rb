require 'test_helper'

class VolunteerDefaultEventsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:volunteer_default_events)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_volunteer_default_event
    assert_difference('VolunteerDefaultEvent.count') do
      post :create, :volunteer_default_event => { }
    end

    assert_redirected_to volunteer_default_event_path(assigns(:volunteer_default_event))
  end

  def test_should_show_volunteer_default_event
    get :show, :id => volunteer_default_events(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => volunteer_default_events(:one).id
    assert_response :success
  end

  def test_should_update_volunteer_default_event
    put :update, :id => volunteer_default_events(:one).id, :volunteer_default_event => { }
    assert_redirected_to volunteer_default_event_path(assigns(:volunteer_default_event))
  end

  def test_should_destroy_volunteer_default_event
    assert_difference('VolunteerDefaultEvent.count', -1) do
      delete :destroy, :id => volunteer_default_events(:one).id
    end

    assert_redirected_to volunteer_default_events_path
  end
end
