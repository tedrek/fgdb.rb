require File.dirname(__FILE__) + '/../test_helper'

class VolunteerTaskTypeTest < ActiveSupport::TestCase
  NEW_VOLUNTEER_TASK_TYPE = {}	# e.g. {:name => 'Test VolunteerTaskType', :description => 'Dummy'}
  REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = volunteer_task_types(:first)
  end

  def test_raw_validation
    volunteer_task_type = VolunteerTaskType.new
    if REQ_ATTR_NAMES.blank?
      assert volunteer_task_type.valid?, "VolunteerTaskType should be valid without initialisation parameters"
    else
      # If VolunteerTaskType has validation, then use the following:
      assert !volunteer_task_type.valid?, "VolunteerTaskType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each do |attr_name|
        assert(volunteer_task_type.errors[attr_name.to_sym].any?,
               "Should be an error message for :#{attr_name}")
      end
    end
  end

  def test_new
    volunteer_task_type = VolunteerTaskType.new(NEW_VOLUNTEER_TASK_TYPE)
    assert volunteer_task_type.valid?, "VolunteerTaskType should be valid"
    NEW_VOLUNTEER_TASK_TYPE.each do |attr_name|
      assert_equal NEW_VOLUNTEER_TASK_TYPE[attr_name], volunteer_task_type.attributes[attr_name], "VolunteerTaskType.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_volunteer_task_type = NEW_VOLUNTEER_TASK_TYPE.clone
      tmp_volunteer_task_type.delete attr_name.to_sym
      volunteer_task_type = VolunteerTaskType.new(tmp_volunteer_task_type)
      assert !volunteer_task_type.valid?, "VolunteerTaskType should be invalid, as @#{attr_name} is invalid"
      assert(volunteer_task_type.errors[attr_name.to_sym].any?,
             "Should be an error message for :#{attr_name}")
    end
  end

  def test_duplicate
    current_volunteer_task_type = VolunteerTaskType.find(:first)
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      volunteer_task_type = VolunteerTaskType.new(NEW_VOLUNTEER_TASK_TYPE.merge(attr_name.to_sym => current_volunteer_task_type[attr_name]))
      assert !volunteer_task_type.valid?, "VolunteerTaskType should be invalid, as @#{attr_name} is a duplicate"
      assert(volunteer_task_type.errors[attr_name.to_sym].any?,
             "Should be an error message for :#{attr_name}")
    end
  end
end
