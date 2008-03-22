require File.dirname(__FILE__) + '/../test_helper'

class ContactMethodTest < Test::Unit::TestCase
  fixtures :contact_types, :contacts, :contact_method_types, :contact_methods, :users

  TYPE = ContactMethodType.new({:description => "cat"})
  TYPE.save
  CONTACT = Contact.new({:postal_code => '1', :first_name => "cat", :created_by => 1})
  CONTACT.save
  NEW_CONTACT_METHOD = {:contact_method_type => TYPE, :contact => CONTACT}
  REQ_ATTR_NAMES        = %w( contact contact_method_type  )
  DUPLICATE_ATTR_NAMES = %w( )

  def setup
    # Retrieve fixtures via their name
    # @first = contact_methods(:first)
  end

  def test_raw_validation
    contact_method = ContactMethod.new
    if REQ_ATTR_NAMES.blank?
      assert contact_method.valid?, "ContactMethod should be valid without initialisation parameters"
    else
      # If ContactMethod has validation, then use the following:
      assert !contact_method.valid?, "ContactMethod should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert contact_method.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

  def test_new
    contact_method = ContactMethod.new(NEW_CONTACT_METHOD)
    assert contact_method.valid?, "ContactMethod should be valid"
     NEW_CONTACT_METHOD.each do |attr_name|
      assert_equal NEW_CONTACT_METHOD[attr_name], contact_method.attributes[attr_name], "ContactMethod.@#{attr_name.to_s} incorrect"
    end
   end

  def test_validates_presence_of
     REQ_ATTR_NAMES.each do |attr_name|
      tmp_contact_method = NEW_CONTACT_METHOD.clone
      tmp_contact_method.delete attr_name.to_sym
      contact_method = ContactMethod.new(tmp_contact_method)
      assert !contact_method.valid?, "ContactMethod should be invalid, as @#{attr_name} is invalid"
      assert contact_method.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
   end

  def test_duplicate
    current_contact_method = ContactMethod.find(:first)
     DUPLICATE_ATTR_NAMES.each do |attr_name|
       contact_method = ContactMethod.new(NEW_CONTACT_METHOD.merge(attr_name.to_sym => current_contact_method[attr_name]))
      assert !contact_method.valid?, "ContactMethod should be invalid, as @#{attr_name} is a duplicate"
      assert contact_method.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
  end
end

