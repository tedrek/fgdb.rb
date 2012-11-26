require 'test_helper'

class MeetingMindersControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:meeting_minders)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_meeting_minder
    assert_difference('MeetingMinder.count') do
      post :create, :meeting_minder => { }
    end

    assert_redirected_to meeting_minder_path(assigns(:meeting_minder))
  end

  def test_should_show_meeting_minder
    get :show, :id => meeting_minders(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => meeting_minders(:one).id
    assert_response :success
  end

  def test_should_update_meeting_minder
    put :update, :id => meeting_minders(:one).id, :meeting_minder => { }
    assert_redirected_to meeting_minder_path(assigns(:meeting_minder))
  end

  def test_should_destroy_meeting_minder
    assert_difference('MeetingMinder.count', -1) do
      delete :destroy, :id => meeting_minders(:one).id
    end

    assert_redirected_to meeting_minders_path
  end
end
