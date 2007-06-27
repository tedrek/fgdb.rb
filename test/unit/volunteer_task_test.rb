require File.dirname(__FILE__) + '/../test_helper'

class VolunteerTaskTest < Test::Unit::TestCase
  fixtures :volunteer_tasks, :volunteer_task_types

  NEW_VOLUNTEER_TASK = {
    :duration => 1.5,
    :date_performed => Date.today,
    :contact_id => 1,
    :volunteer_task_types => [VolunteerTaskType.find(46)]
  }
  REQ_ATTR_NAMES 			 = %w( contact_id date_performed) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = volunteer_tasks(:first)
  end

  def test_raw_validation
    volunteer_task = VolunteerTask.new
    if REQ_ATTR_NAMES.blank?
      assert volunteer_task.valid?, "VolunteerTask should be valid without initialisation parameters"
    else
      # If VolunteerTask has validation, then use the following:
      assert !volunteer_task.valid?, "VolunteerTask should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert volunteer_task.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    volunteer_task = VolunteerTask.new(NEW_VOLUNTEER_TASK)
    assert volunteer_task.valid?, "VolunteerTask should be valid"
   	NEW_VOLUNTEER_TASK.each do |attr_name|
      assert_equal NEW_VOLUNTEER_TASK[attr_name], volunteer_task.attributes[attr_name], "VolunteerTask.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_volunteer_task = NEW_VOLUNTEER_TASK.clone
			tmp_volunteer_task.delete attr_name.to_sym
			volunteer_task = VolunteerTask.new(tmp_volunteer_task)
			assert !volunteer_task.valid?, "VolunteerTask should be invalid, as @#{attr_name} is invalid"
    	assert volunteer_task.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_duplicate
    current_volunteer_task = VolunteerTask.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
      volunteer_task = VolunteerTask.new(NEW_VOLUNTEER_TASK.merge(attr_name.to_sym => current_volunteer_task[attr_name]))
      assert !volunteer_task.valid?, "VolunteerTask should be invalid, as @#{attr_name} is a duplicate"
      assert volunteer_task.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end
end

