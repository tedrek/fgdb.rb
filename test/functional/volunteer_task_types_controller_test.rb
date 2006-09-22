require File.dirname(__FILE__) + '/../test_helper'
require 'volunteer_task_types_controller'

# Re-raise errors caught by the controller.
class VolunteerTaskTypesController; def rescue_action(e) raise e end; end

class VolunteerTaskTypesControllerTest < Test::Unit::TestCase
  fixtures :volunteer_task_types

	NEW_VOLUNTEER_TASK_TYPE = {}	# e.g. {:name => 'Test VolunteerTaskType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = VolunteerTaskTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = volunteer_task_types(:first)
		@first = VolunteerTaskType.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'volunteer_task_types/component'
    volunteer_task_types = check_attrs(%w(volunteer_task_types))
    assert_equal VolunteerTaskType.find(:all).length, volunteer_task_types.length, "Incorrect number of volunteer_task_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'volunteer_task_types/component'
    volunteer_task_types = check_attrs(%w(volunteer_task_types))
    assert_equal VolunteerTaskType.find(:all).length, volunteer_task_types.length, "Incorrect number of volunteer_task_types shown"
  end

  def test_create
  	volunteer_task_type_count = VolunteerTaskType.find(:all).length
    post :create, {:volunteer_task_type => NEW_VOLUNTEER_TASK_TYPE}
    volunteer_task_type, successful = check_attrs(%w(volunteer_task_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal volunteer_task_type_count + 1, VolunteerTaskType.find(:all).length, "Expected an additional VolunteerTaskType"
  end

  def test_create_xhr
  	volunteer_task_type_count = VolunteerTaskType.find(:all).length
    xhr :post, :create, {:volunteer_task_type => NEW_VOLUNTEER_TASK_TYPE}
    volunteer_task_type, successful = check_attrs(%w(volunteer_task_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal volunteer_task_type_count + 1, VolunteerTaskType.find(:all).length, "Expected an additional VolunteerTaskType"
  end

  def test_update
  	volunteer_task_type_count = VolunteerTaskType.find(:all).length
    post :update, {:id => @first.id, :volunteer_task_type => @first.attributes.merge(NEW_VOLUNTEER_TASK_TYPE)}
    volunteer_task_type, successful = check_attrs(%w(volunteer_task_type successful))
    assert successful, "Should be successful"
    volunteer_task_type.reload
   	NEW_VOLUNTEER_TASK_TYPE.each do |attr_name|
      assert_equal NEW_VOLUNTEER_TASK_TYPE[attr_name], volunteer_task_type.attributes[attr_name], "@volunteer_task_type.#{attr_name.to_s} incorrect"
    end
    assert_equal volunteer_task_type_count, VolunteerTaskType.find(:all).length, "Number of VolunteerTaskTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	volunteer_task_type_count = VolunteerTaskType.find(:all).length
    xhr :post, :update, {:id => @first.id, :volunteer_task_type => @first.attributes.merge(NEW_VOLUNTEER_TASK_TYPE)}
    volunteer_task_type, successful = check_attrs(%w(volunteer_task_type successful))
    assert successful, "Should be successful"
    volunteer_task_type.reload
   	NEW_VOLUNTEER_TASK_TYPE.each do |attr_name|
      assert_equal NEW_VOLUNTEER_TASK_TYPE[attr_name], volunteer_task_type.attributes[attr_name], "@volunteer_task_type.#{attr_name.to_s} incorrect"
    end
    assert_equal volunteer_task_type_count, VolunteerTaskType.find(:all).length, "Number of VolunteerTaskTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	volunteer_task_type_count = VolunteerTaskType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal volunteer_task_type_count - 1, VolunteerTaskType.find(:all).length, "Number of VolunteerTaskTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	volunteer_task_type_count = VolunteerTaskType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal volunteer_task_type_count - 1, VolunteerTaskType.find(:all).length, "Number of VolunteerTaskTypes should be one less"
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
