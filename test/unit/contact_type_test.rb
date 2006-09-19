require File.dirname(__FILE__) + '/../test_helper'

class ContactTypeTest < Test::Unit::TestCase
  fixtures :contact_types

  NEW_CONTACT_TYPE = {}    # e.g. {:name => 'Test ContactType', :description => 'Dummy'}
  REQ_ATTR_NAMES              = %w( ) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = contact_types(:first)
  end

  def test_raw_validation
    contact_type = ContactType.new
    if REQ_ATTR_NAMES.blank?
      assert contact_type.valid?, "ContactType should be valid without initialisation parameters"
    else
      # If ContactType has validation, then use the following:
      assert !contact_type.valid?, "ContactType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert contact_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    contact_type = ContactType.new(NEW_CONTACT_TYPE)
    assert contact_type.valid?, "ContactType should be valid"
    NEW_CONTACT_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_TYPE[attr_name], contact_type.attributes[attr_name], "ContactType.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_contact_type = NEW_CONTACT_TYPE.clone
      tmp_contact_type.delete attr_name.to_sym
      contact_type = ContactType.new(tmp_contact_type)
      assert !contact_type.valid?, "ContactType should be invalid, as @#{attr_name} is invalid"
      assert contact_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end

  def test_duplicate
    current_contact_type = ContactType.find_first
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      contact_type = ContactType.new(NEW_CONTACT_TYPE.merge(attr_name.to_sym => current_contact_type[attr_name]))
      assert !contact_type.valid?, "ContactType should be invalid, as @#{attr_name} is a duplicate"
      assert contact_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end
end

