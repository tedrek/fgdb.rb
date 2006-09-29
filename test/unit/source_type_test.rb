require File.dirname(__FILE__) + '/../test_helper'

class SourceTypeTest < Test::Unit::TestCase
  fixtures :source_types

	NEW_SOURCE_TYPE = {}	# e.g. {:name => 'Test SourceType', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = source_types(:first)
  end

  def test_raw_validation
    source_type = SourceType.new
    if REQ_ATTR_NAMES.blank?
      assert source_type.valid?, "SourceType should be valid without initialisation parameters"
    else
      # If SourceType has validation, then use the following:
      assert !source_type.valid?, "SourceType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert source_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    source_type = SourceType.new(NEW_SOURCE_TYPE)
    assert source_type.valid?, "SourceType should be valid"
   	NEW_SOURCE_TYPE.each do |attr_name|
      assert_equal NEW_SOURCE_TYPE[attr_name], source_type.attributes[attr_name], "SourceType.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_source_type = NEW_SOURCE_TYPE.clone
			tmp_source_type.delete attr_name.to_sym
			source_type = SourceType.new(tmp_source_type)
			assert !source_type.valid?, "SourceType should be invalid, as @#{attr_name} is invalid"
    	assert source_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_source_type = SourceType.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		source_type = SourceType.new(NEW_SOURCE_TYPE.merge(attr_name.to_sym => current_source_type[attr_name]))
			assert !source_type.valid?, "SourceType should be invalid, as @#{attr_name} is a duplicate"
    	assert source_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

