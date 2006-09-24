require File.dirname(__FILE__) + '/../test_helper'

class DonatedGizmoTest < Test::Unit::TestCase
  fixtures :donated_gizmos

	NEW_DONATED_GIZMO = {}	# e.g. {:name => 'Test DonatedGizmo', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = donated_gizmos(:first)
  end

  def test_raw_validation
    donated_gizmo = DonatedGizmo.new
    if REQ_ATTR_NAMES.blank?
      assert donated_gizmo.valid?, "DonatedGizmo should be valid without initialisation parameters"
    else
      # If DonatedGizmo has validation, then use the following:
      assert !donated_gizmo.valid?, "DonatedGizmo should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert donated_gizmo.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    donated_gizmo = DonatedGizmo.new(NEW_DONATED_GIZMO)
    assert donated_gizmo.valid?, "DonatedGizmo should be valid"
   	NEW_DONATED_GIZMO.each do |attr_name|
      assert_equal NEW_DONATED_GIZMO[attr_name], donated_gizmo.attributes[attr_name], "DonatedGizmo.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_donated_gizmo = NEW_DONATED_GIZMO.clone
			tmp_donated_gizmo.delete attr_name.to_sym
			donated_gizmo = DonatedGizmo.new(tmp_donated_gizmo)
			assert !donated_gizmo.valid?, "DonatedGizmo should be invalid, as @#{attr_name} is invalid"
    	assert donated_gizmo.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_donated_gizmo = DonatedGizmo.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		donated_gizmo = DonatedGizmo.new(NEW_DONATED_GIZMO.merge(attr_name.to_sym => current_donated_gizmo[attr_name]))
			assert !donated_gizmo.valid?, "DonatedGizmo should be invalid, as @#{attr_name} is a duplicate"
    	assert donated_gizmo.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

