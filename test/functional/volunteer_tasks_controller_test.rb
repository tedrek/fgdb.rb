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
    @first.volunteer_task_type = VolunteerTaskType.find(46)
  end

  def test_truth
    assert true
  end

end
