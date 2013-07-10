require 'test_helper'

class BuilderTasksControllerTest < ActionController::TestCase
  fixtures :contacts, :users, :roles, :roles_users, :builder_tasks

  def setup
    login_as :quentin
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_builder_task
    assert_difference('BuilderTask.count') do
      post :create, :builder_task => {
        :contact_id => contacts(:test_contact).id,
        :action_id => Action.find(:first).id,
      }
    end
    assert_response :redirect
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
    assert_response :redirect
  end
end
