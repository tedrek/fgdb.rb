require File.dirname(__FILE__) + '/../test_helper'
require 'volunteer_tasks_controller'

# Re-raise errors caught by the controller.
class VolunteerTasksController; def rescue_action(e) raise e end; end

class VolunteerTasksControllerTest < Test::Unit::TestCase
  fixtures :contacts, :volunteer_task_types, :volunteer_tasks, :users, :roles, :roles_users

  NEW_VOLUNTEER_TASK = {
    'duration' => 3,
    'contact_id' => 12
  }
  NEW_VOLUNTEER_TASK_TYPES = [ '22' ]

  def setup
    @controller = VolunteerTasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_list
    get :list
    assert_response :success
    assert_template 'list'
  end

  def test_component_with_contact
    first = Contact.find(:first)
    first.volunteer_tasks << an_hour_of_programming
    post :component, :contact_id => first.id, :limit_by_contact_id => true
    assert_response :success
    assert_template 'component'
    contact = assigns(:contact)
    assert_kind_of Contact, contact
    assert_equal first.id, contact.id
    tasks = assigns(:volunteer_tasks)
    assert ! tasks.empty?
    tasks.each {|task|
      assert_equal first.id, task.contact_id
    }
  end
end
