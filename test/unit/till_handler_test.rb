require File.dirname(__FILE__) + '/../test_helper'

class TillHandlerTest < Test::Unit::TestCase
  fixtures :till_handlers

	NEW_TILL_HANDLER = {}	# e.g. {:name => 'Test TillHandler', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = till_handlers(:first)
  end

  def test_raw_validation
    till_handler = TillHandler.new
    if REQ_ATTR_NAMES.blank?
      assert till_handler.valid?, "TillHandler should be valid without initialisation parameters"
    else
      # If TillHandler has validation, then use the following:
      assert !till_handler.valid?, "TillHandler should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert till_handler.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    till_handler = TillHandler.new(NEW_TILL_HANDLER)
    assert till_handler.valid?, "TillHandler should be valid"
   	NEW_TILL_HANDLER.each do |attr_name|
      assert_equal NEW_TILL_HANDLER[attr_name], till_handler.attributes[attr_name], "TillHandler.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_till_handler = NEW_TILL_HANDLER.clone
			tmp_till_handler.delete attr_name.to_sym
			till_handler = TillHandler.new(tmp_till_handler)
			assert !till_handler.valid?, "TillHandler should be invalid, as @#{attr_name} is invalid"
    	assert till_handler.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_till_handler = TillHandler.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		till_handler = TillHandler.new(NEW_TILL_HANDLER.merge(attr_name.to_sym => current_till_handler[attr_name]))
			assert !till_handler.valid?, "TillHandler should be invalid, as @#{attr_name} is a duplicate"
    	assert till_handler.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

