require File.dirname(__FILE__) + '/../test_helper'

class ContactMethodTypeTest < ActiveSupport::TestCase
  NEW_CONTACT_METHOD_TYPE = {}  # e.g. {:name => 'Test ContactMethodType', :description => 'Dummy'}
  REQ_ATTR_NAMES        = %w( ) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = contact_method_types(:first)
  end

  def test_raw_validation
    contact_method_type = ContactMethodType.new
    if REQ_ATTR_NAMES.blank?
      assert contact_method_type.valid?, "ContactMethodType should be valid without initialisation parameters"
    else
      # If ContactMethodType has validation, then use the following:
      assert !contact_method_type.valid?, "ContactMethodType should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert contact_method_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    contact_method_type = ContactMethodType.new(NEW_CONTACT_METHOD_TYPE)
    assert contact_method_type.valid?, "ContactMethodType should be valid"
     NEW_CONTACT_METHOD_TYPE.each do |attr_name|
      assert_equal NEW_CONTACT_METHOD_TYPE[attr_name], contact_method_type.attributes[attr_name], "ContactMethodType.@#{attr_name.to_s} incorrect"
    end
   end

  def test_validates_presence_of
     REQ_ATTR_NAMES.each do |attr_name|
      tmp_contact_method_type = NEW_CONTACT_METHOD_TYPE.clone
      tmp_contact_method_type.delete attr_name.to_sym
      contact_method_type = ContactMethodType.new(tmp_contact_method_type)
      assert !contact_method_type.valid?, "ContactMethodType should be invalid, as @#{attr_name} is invalid"
      assert contact_method_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
   end

  def test_duplicate
    current_contact_method_type = ContactMethodType.find(:first)
     DUPLICATE_ATTR_NAMES.each do |attr_name|
       contact_method_type = ContactMethodType.new(NEW_CONTACT_METHOD_TYPE.merge(attr_name.to_sym => current_contact_method_type[attr_name]))
      assert !contact_method_type.valid?, "ContactMethodType should be invalid, as @#{attr_name} is a duplicate"
      assert contact_method_type.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end
end

