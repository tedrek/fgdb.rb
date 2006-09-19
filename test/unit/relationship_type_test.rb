require File.dirname(__FILE__) + '/../test_helper'

class RelationshipTypeTest < Test::Unit::TestCase
  fixtures :relationship_types

	NEW_RELATIONSHIP_TYPE = {}	# e.g. {:name => 'Test RelationshipType', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = relationship_types(:first)
  end

  def test_raw_validation
    relationship_type = RelationshipType.new
    if REQ_ATTR_NAMES.blank?
      assert relationship_type.valid?, "RelationshipType should be valid without initialisation parameters"
    else
      # If RelationshipType has validation, then use the following:
      assert !relationship_type.valid?, "RelationshipType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert relationship_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    relationship_type = RelationshipType.new(NEW_RELATIONSHIP_TYPE)
    assert relationship_type.valid?, "RelationshipType should be valid"
   	NEW_RELATIONSHIP_TYPE.each do |attr_name|
      assert_equal NEW_RELATIONSHIP_TYPE[attr_name], relationship_type.attributes[attr_name], "RelationshipType.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_relationship_type = NEW_RELATIONSHIP_TYPE.clone
			tmp_relationship_type.delete attr_name.to_sym
			relationship_type = RelationshipType.new(tmp_relationship_type)
			assert !relationship_type.valid?, "RelationshipType should be invalid, as @#{attr_name} is invalid"
    	assert relationship_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_relationship_type = RelationshipType.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		relationship_type = RelationshipType.new(NEW_RELATIONSHIP_TYPE.merge(attr_name.to_sym => current_relationship_type[attr_name]))
			assert !relationship_type.valid?, "RelationshipType should be invalid, as @#{attr_name} is a duplicate"
    	assert relationship_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

