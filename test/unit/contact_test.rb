require File.dirname(__FILE__) + '/../test_helper'

class ContactTest < Test::Unit::TestCase
  fixtures :contacts

  NEW_CONTACT = {:postal_code => 1 }  # e.g. {:name => 'Test Contact', :description => 'Dummy'}
  REQ_ATTR_NAMES        = %w( postal_code ) # name of fields that must be present, e.g. %(name description)
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
    current_contact = Contact.find_first
     DUPLICATE_ATTR_NAMES.each do |attr_name|
       contact = Contact.new(NEW_CONTACT.merge(attr_name.to_sym => current_contact[attr_name]))
      assert !contact.valid?, "Contact should be invalid, as @#{attr_name} is a duplicate"
      assert contact.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end
end

