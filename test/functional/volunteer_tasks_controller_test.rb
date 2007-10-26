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

  def setup
    @controller = VolunteerTasksController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first = VolunteerTask.find(:first)
    @first.volunteer_task_type = VolunteerTaskType.find(46)
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
