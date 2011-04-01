require 'test_helper'

class BuilderTasksControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:builder_tasks)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_builder_task
    assert_difference('BuilderTask.count') do
      post :create, :builder_task => { }
    end

    assert_redirected_to builder_task_path(assigns(:builder_task))
  end

  def test_should_show_builder_task
    get :show, :id => builder_tasks(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => builder_tasks(:one).id
    assert_response :success
  end

  def test_should_update_builder_task
    put :update, :id => builder_tasks(:one).id, :builder_task => { }
    assert_redirected_to builder_task_path(assigns(:builder_task))
  end

  def test_should_destroy_builder_task
    assert_difference('BuilderTask.count', -1) do
      delete :destroy, :id => builder_tasks(:one).id
    end

    assert_redirected_to builder_tasks_path
  end
end
