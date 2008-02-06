require File.dirname(__FILE__) + '/../test_helper'

class DiscountScheduleTest < Test::Unit::TestCase
  fixtures :discount_schedules

	NEW_DISCOUNT_SCHEDULE = { :name => 'foo'}	# e.g. {:name => 'Test DiscountSchedule', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( name ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = discount_schedules(:first)
  end

  def test_raw_validation
    discount_schedule = DiscountSchedule.new
    if REQ_ATTR_NAMES.blank?
      assert discount_schedule.valid?, "DiscountSchedule should be valid without initialisation parameters"
    else
      # If DiscountSchedule has validation, then use the following:
      assert !discount_schedule.valid?, "DiscountSchedule should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert discount_schedule.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    discount_schedule = DiscountSchedule.new(NEW_DISCOUNT_SCHEDULE)
    assert discount_schedule.valid?, "DiscountSchedule should be valid"
   	NEW_DISCOUNT_SCHEDULE.each do |attr_name|
      assert_equal NEW_DISCOUNT_SCHEDULE[attr_name], discount_schedule.attributes[attr_name], "DiscountSchedule.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_discount_schedule = NEW_DISCOUNT_SCHEDULE.clone
			tmp_discount_schedule.delete attr_name.to_sym
			discount_schedule = DiscountSchedule.new(tmp_discount_schedule)
			assert !discount_schedule.valid?, "DiscountSchedule should be invalid, as @#{attr_name} is invalid"
    	assert discount_schedule.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_discount_schedule = DiscountSchedule.find(:first)
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		discount_schedule = DiscountSchedule.new(NEW_DISCOUNT_SCHEDULE.merge(attr_name.to_sym => current_discount_schedule[attr_name]))
			assert !discount_schedule.valid?, "DiscountSchedule should be invalid, as @#{attr_name} is a duplicate"
    	assert discount_schedule.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

