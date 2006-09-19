require File.dirname(__FILE__) + '/../test_helper'

class RelationshipTest < Test::Unit::TestCase
  fixtures :relationships

	NEW_RELATIONSHIP = {}	# e.g. {:name => 'Test Relationship', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = relationships(:first)
  end

  def test_raw_validation
    relationship = Relationship.new
    if REQ_ATTR_NAMES.blank?
      assert relationship.valid?, "Relationship should be valid without initialisation parameters"
    else
      # If Relationship has validation, then use the following:
      assert !relationship.valid?, "Relationship should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert relationship.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    relationship = Relationship.new(NEW_RELATIONSHIP)
    assert relationship.valid?, "Relationship should be valid"
   	NEW_RELATIONSHIP.each do |attr_name|
      assert_equal NEW_RELATIONSHIP[attr_name], relationship.attributes[attr_name], "Relationship.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_relationship = NEW_RELATIONSHIP.clone
			tmp_relationship.delete attr_name.to_sym
			relationship = Relationship.new(tmp_relationship)
			assert !relationship.valid?, "Relationship should be invalid, as @#{attr_name} is invalid"
    	assert relationship.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_relationship = Relationship.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		relationship = Relationship.new(NEW_RELATIONSHIP.merge(attr_name.to_sym => current_relationship[attr_name]))
			assert !relationship.valid?, "Relationship should be invalid, as @#{attr_name} is a duplicate"
    	assert relationship.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

