require File.dirname(__FILE__) + '/../test_helper'
require 'volunteer_tasks_controller'

# Re-raise errors caught by the controller.
class VolunteerTasksController; def rescue_action(e) raise e end; end

class VolunteerTasksControllerTest < ActionController::TestCase
  fixtures :contacts, :volunteer_tasks, :users, :roles_users

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
  end

  def test_component_with_contact
    first = Contact.find(:first)
    first.volunteer_tasks << VolunteerTask.new(
                          :volunteer_task_type => VolunteerTaskType.find(:first),
                          :community_service_type => CommunityServiceType.find(:first),
                          :program => Program.find(:first),
                          :duration => 4,
                          :date_performed => Date.today)
    assert first.save!
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

  # Check a new form can be shown
  def test_new_form
    get :new
    assert_response :success
  end

  test "creating a new volunteer task" do
    assert_difference 'VolunteerTask.count' do
      post :create, volunteer_task: {
        contact_id: '1',
        date_performed: '2000-01-01',
        duration: '1.5',
        volunteer_task_type_id: '29',  # recycling (adoption)
        program_id: '1', # adoption
      }
      assert_response :success
    end
  end

  def test_update_task_types
    get :update_task_types, {:day => '2012-12-25'}
  end
end
