require File.dirname(__FILE__) + '/../test_helper'
require 'volunteer_tasks_controller'

# Re-raise errors caught by the controller.
class VolunteerTasksController; def rescue_action(e) raise e end; end

class VolunteerTasksControllerTest < Test::Unit::TestCase
  fixtures :contacts, :volunteer_task_types, :volunteer_tasks

  NEW_VOLUNTEER_TASK = {
    'duration' => 3,
    'contact_id' => 12
  }
  NEW_VOLUNTEER_TASK_TYPES = [ '22' ]

  def setup
    @controller = VolunteerTasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = VolunteerTask.find_first
    @first.volunteer_task_types = [VolunteerTaskType.find(46)]
  end

  def test_component
    get :component
    assert_response :success
    assert_template 'volunteer_tasks/component'
    volunteer_tasks = check_attrs(%w(volunteer_tasks))
    known_tasks = VolunteerTask.find(:all).length
    if( known_tasks > @controller.default_per_page )
      known_tasks = @controller.default_per_page
    end
    assert_equal known_tasks, volunteer_tasks.length, "Incorrect number of volunteer_tasks shown"
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'volunteer_tasks/component'
    volunteer_tasks = check_attrs(%w(volunteer_tasks))
    known_tasks = VolunteerTask.find(:all).length
    if( known_tasks > @controller.default_per_page )
      known_tasks = @controller.default_per_page
    end
    assert_equal known_tasks, volunteer_tasks.length, "Incorrect number of volunteer_tasks shown"
  end

  def test_create_xhr
  	volunteer_task_count = VolunteerTask.find(:all).length
    xhr :post, :create, {:volunteer_task => NEW_VOLUNTEER_TASK, :volunteer_task_types => NEW_VOLUNTEER_TASK_TYPES}
    volunteer_task, successful = check_attrs(%w(volunteer_task successful))
#    assert successful, "Should be successful"
#    assert_response :success
    assert_template 'create.rjs'
#    assert_equal volunteer_task_count + 1, VolunteerTask.find(:all).length, "Expected an additional VolunteerTask"
  end

  def test_update_xhr
  	volunteer_task_count = VolunteerTask.find(:all).length
    xhr :post, :update, {:id => @first.id, :volunteer_task => @first.attributes.merge(NEW_VOLUNTEER_TASK)}
    volunteer_task, successful = check_attrs(%w(volunteer_task successful))
    assert successful, "Should be successful"
    volunteer_task.reload
    NEW_VOLUNTEER_TASK.keys.each do |attr_name|
      assert_equal NEW_VOLUNTEER_TASK[attr_name], volunteer_task.attributes[attr_name], "@volunteer_task.#{attr_name.to_s} incorrect"
    end
    assert_equal volunteer_task_count, VolunteerTask.find(:all).length, "Number of VolunteerTasks should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	volunteer_task_count = VolunteerTask.find(:all).length
    post :destroy, {:id => @first.id}
    assert_equal volunteer_task_count - 1, VolunteerTask.find(:all).length, "Number of VolunteerTasks should be one less"
  end

  def test_destroy_xhr
  	volunteer_task_count = VolunteerTask.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal volunteer_task_count - 1, VolunteerTask.find(:all).length, "Number of VolunteerTasks should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
