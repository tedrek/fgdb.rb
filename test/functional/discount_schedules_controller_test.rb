require File.dirname(__FILE__) + '/../test_helper'
require 'discount_schedules_controller'

# Re-raise errors caught by the controller.
class DiscountSchedulesController; def rescue_action(e) raise e end; end

class DiscountSchedulesControllerTest < Test::Unit::TestCase
  fixtures :discount_schedules

	NEW_DISCOUNT_SCHEDULE = {}	# e.g. {:name => 'Test DiscountSchedule', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DiscountSchedulesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = discount_schedules(:first)
		@first = DiscountSchedule.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'discount_schedules/component'
    discount_schedules = check_attrs(%w(discount_schedules))
    assert_equal DiscountSchedule.find(:all).length, discount_schedules.length, "Incorrect number of discount_schedules shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'discount_schedules/component'
    discount_schedules = check_attrs(%w(discount_schedules))
    assert_equal DiscountSchedule.find(:all).length, discount_schedules.length, "Incorrect number of discount_schedules shown"
  end

  def test_create
  	discount_schedule_count = DiscountSchedule.find(:all).length
    post :create, {:discount_schedule => NEW_DISCOUNT_SCHEDULE}
    discount_schedule, successful = check_attrs(%w(discount_schedule successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal discount_schedule_count + 1, DiscountSchedule.find(:all).length, "Expected an additional DiscountSchedule"
  end

  def test_create_xhr
  	discount_schedule_count = DiscountSchedule.find(:all).length
    xhr :post, :create, {:discount_schedule => NEW_DISCOUNT_SCHEDULE}
    discount_schedule, successful = check_attrs(%w(discount_schedule successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal discount_schedule_count + 1, DiscountSchedule.find(:all).length, "Expected an additional DiscountSchedule"
  end

  def test_update
  	discount_schedule_count = DiscountSchedule.find(:all).length
    post :update, {:id => @first.id, :discount_schedule => @first.attributes.merge(NEW_DISCOUNT_SCHEDULE)}
    discount_schedule, successful = check_attrs(%w(discount_schedule successful))
    assert successful, "Should be successful"
    discount_schedule.reload
   	NEW_DISCOUNT_SCHEDULE.each do |attr_name|
      assert_equal NEW_DISCOUNT_SCHEDULE[attr_name], discount_schedule.attributes[attr_name], "@discount_schedule.#{attr_name.to_s} incorrect"
    end
    assert_equal discount_schedule_count, DiscountSchedule.find(:all).length, "Number of DiscountSchedules should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	discount_schedule_count = DiscountSchedule.find(:all).length
    xhr :post, :update, {:id => @first.id, :discount_schedule => @first.attributes.merge(NEW_DISCOUNT_SCHEDULE)}
    discount_schedule, successful = check_attrs(%w(discount_schedule successful))
    assert successful, "Should be successful"
    discount_schedule.reload
   	NEW_DISCOUNT_SCHEDULE.each do |attr_name|
      assert_equal NEW_DISCOUNT_SCHEDULE[attr_name], discount_schedule.attributes[attr_name], "@discount_schedule.#{attr_name.to_s} incorrect"
    end
    assert_equal discount_schedule_count, DiscountSchedule.find(:all).length, "Number of DiscountSchedules should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	discount_schedule_count = DiscountSchedule.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal discount_schedule_count - 1, DiscountSchedule.find(:all).length, "Number of DiscountSchedules should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	discount_schedule_count = DiscountSchedule.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal discount_schedule_count - 1, DiscountSchedule.find(:all).length, "Number of DiscountSchedules should be one less"
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
