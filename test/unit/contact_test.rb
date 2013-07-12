require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < ActiveSupport::TestCase
  load_all_fixtures

  NEW_CONTACT = {:first_name=>"Joe", :middle_name=>'', :surname=> 'Strummer',
    :organization=>'', :extra_address=>'', :address=>'Elsewhere',
    :city=>'London', :state_or_province=>'UK', :postal_code=>'123',
    :country=>'Britain', :notes=>'', :created_by=>1}
  REQ_ATTR_NAMES        = %w( first_name ) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = contacts(:first)
  end

  def test_raw_validation
    contact = Contact.new
    if REQ_ATTR_NAMES.blank?
      assert contact.valid?, "Contact should be valid without initialisation parameters"
    else
      # If Contact has validation, then use the following:
      assert !contact.valid?, "Contact should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert contact.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    contact = Contact.new(NEW_CONTACT)
    assert contact.valid?, "Contact should be valid"
    NEW_CONTACT.each do |attr_name|
      assert_equal NEW_CONTACT[attr_name], contact.attributes[attr_name], "Contact.@#{attr_name.to_s} incorrect"
    end
   end

  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_contact = NEW_CONTACT.clone
      tmp_contact.delete attr_name.to_sym
      contact = Contact.new(tmp_contact)
      assert !contact.valid?, "Contact should be invalid, as @#{attr_name} is invalid"
      assert contact.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_duplicate
    current_contact = Contact.find(:first)
     DUPLICATE_ATTR_NAMES.each do |attr_name|
       contact = Contact.new(NEW_CONTACT.merge(attr_name.to_sym => current_contact[attr_name]))
      assert !contact.valid?, "Contact should be invalid, as @#{attr_name} is a duplicate"
      assert contact.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_that_volunteer_tasks_meet_business_rules
    contact = Contact.find(:first)
    contact.volunteer_tasks = []
    assert_equal 0, contact.hours_effective
    assert_equal 0, contact.hours_actual
    assert_equal 0, contact.last_ninety_days_of_actual_hours
    assert_kind_of VolunteerTask, an_hour_of_programming
    contact.volunteer_tasks = [an_hour_of_programming]
    assert_kind_of VolunteerTask, contact.volunteer_tasks[0]
  end

  def test_that_adoption_hours_can_be_calculated_appropriately
    contact = Contact.find(:first)
    contact.volunteer_tasks = []
    assert_equal 0, contact.hours_effective
    contact.volunteer_tasks = [an_hour_of_testing]
    contact.save!
    assert_equal 1, contact.hours_actual
    assert_equal 1, contact.hours_effective
    contact.volunteer_tasks = [an_hour_of_programming, an_hour_of_testing]
    contact.save
    assert_equal 2, contact.hours_effective
    contact.volunteer_tasks = [an_hour_of_programming,
                               an_hour_of_programming(1)]
    contact.save
    assert_equal 2, contact.hours_effective
  end

  def test_that_default_discount_can_be_calculated_appropriately
    contact = Contact.find(:first)
    contact.volunteer_tasks = []
    contact.save
    assert_equal 'no_discount', contact.default_discount_schedule
    contact.volunteer_tasks = [an_hour_of_testing, an_hour_of_testing, an_hour_of_testing, an_hour_of_testing]
    assert_equal 'volunteer', contact.default_discount_schedule
    contact.volunteer_tasks = [an_hour_of_programming, an_hour_of_assembly, an_hour_of_testing, an_hour_of_assembly]
    assert_equal 'volunteer', contact.default_discount_schedule
    contact.volunteer_tasks = [an_hour_of_monitors, an_hour_of_programming]
    assert_equal 'no_discount', contact.default_discount_schedule
    contact.volunteer_tasks = []
    4.times {contact.volunteer_tasks << an_hour_of_programming}
    assert_equal 4.0, contact.effective_discount_hours
    assert_equal 'volunteer', contact.default_discount_schedule
  end

  def test_last_ninety_days
    contact = Contact.find(:first)
    contact.volunteer_tasks = []
    assert_equal 0.0, contact.last_ninety_days_of_effective_hours
  end

  def test_contact_types_includes_volunteer
    contact = Contact.find(:first)
    contact.contact_types = []
    contact.contact_types << ContactType.find_by_description('build')
    contact.save
    assert contact.contact_types.include?(ContactType.find_by_description('volunteer'))
    contact.contact_types = []
    contact.contact_types << ContactType.find_by_description('adopter')
    contact.save
    assert contact.contact_types.include?(ContactType.find_by_description('volunteer'))
  end

end

