require File.dirname(__FILE__) + '/../test_helper'

class ForsaleItemTest < Test::Unit::TestCase
  fixtures :forsale_items

	NEW_FORSALE_ITEM = {}	# e.g. {:name => 'Test ForsaleItem', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = forsale_items(:first)
  end

  def test_raw_validation
    forsale_item = ForsaleItem.new
    if REQ_ATTR_NAMES.blank?
      assert forsale_item.valid?, "ForsaleItem should be valid without initialisation parameters"
    else
      # If ForsaleItem has validation, then use the following:
      assert !forsale_item.valid?, "ForsaleItem should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert forsale_item.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    forsale_item = ForsaleItem.new(NEW_FORSALE_ITEM)
    assert forsale_item.valid?, "ForsaleItem should be valid"
   	NEW_FORSALE_ITEM.each do |attr_name|
      assert_equal NEW_FORSALE_ITEM[attr_name], forsale_item.attributes[attr_name], "ForsaleItem.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_forsale_item = NEW_FORSALE_ITEM.clone
			tmp_forsale_item.delete attr_name.to_sym
			forsale_item = ForsaleItem.new(tmp_forsale_item)
			assert !forsale_item.valid?, "ForsaleItem should be invalid, as @#{attr_name} is invalid"
    	assert forsale_item.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_forsale_item = ForsaleItem.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		forsale_item = ForsaleItem.new(NEW_FORSALE_ITEM.merge(attr_name.to_sym => current_forsale_item[attr_name]))
			assert !forsale_item.valid?, "ForsaleItem should be invalid, as @#{attr_name} is a duplicate"
    	assert forsale_item.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

