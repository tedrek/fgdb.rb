require File.dirname(__FILE__) + '/../test_helper'

class VolunteerTaskTest < ActiveSupport::TestCase
  fixtures :volunteer_tasks, :contacts

  def new_volunteer_task
    type = VolunteerTaskType.find_by_hours_multiplier(1.0)#new({:instantiable => true, :description => 'meowing', :hours_multiplier => 1.0})
    #type.save
    {
      :program_id => 1,
      :duration => 1.5,
      :contact_id => 1,
      :date_performed => Time.zone.now.to_date,
      :volunteer_task_type_id => 46
    }
  end
  REQ_ATTR_NAMES                         = %w( contact ) # name of fields that must be present, e.g. %(name description)
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
      REQ_ATTR_NAMES.each do |attr_name|
        assert(volunteer_task.errors[attr_name.to_sym].any?,
               "Should be an error message for :#{attr_name}")
      end
    end
  end

  def test_new
    volunteer_task = VolunteerTask.new(new_volunteer_task)
    assert volunteer_task.valid?, "VolunteerTask should be valid"
    new_volunteer_task.each do |attr_name|
      assert_equal new_volunteer_task[attr_name], volunteer_task.attributes[attr_name], "VolunteerTask.@#{attr_name.to_s} incorrect"
    end
  end

  test "validating contact association" do
    nvt = new_volunteer_task.clone
    nvt.delete :contact_id
    vt = VolunteerTask.new(nvt)
    assert(!vt.valid?, "Volunteer task should be invalid as it has no contact")
    assert(vt.errors[:contact].any?, "There should be an error for :contact")
  end

  def test_duplicate
    current_volunteer_task = VolunteerTask.find(:first)
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      volunteer_task = VolunteerTask.new(new_volunteer_task.merge(attr_name.to_sym => current_volunteer_task[attr_name]))
      assert !volunteer_task.valid?, "VolunteerTask should be invalid, as @#{attr_name} is a duplicate"
      assert(volunteer_task.errors[attr_name.to_sym].any?,
             "Should be an error message for :#{attr_name}")
    end
  end

  def test_effective_duration
    assert_equal 2.0, an_hour_of_monitors.effective_duration
    assert_equal 1.0, an_hour_of_programming.effective_duration
    assert_equal 1.0, an_hour_of_testing.effective_duration
  end
end
