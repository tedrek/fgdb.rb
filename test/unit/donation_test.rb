require File.dirname(__FILE__) + '/../test_helper'

class DonationTest < Test::Unit::TestCase
  fixtures :donations

	NEW_DONATION = {}	# e.g. {:name => 'Test Donation', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = donations(:first)
  end

  def test_raw_validation
    donation = Donation.new
    if REQ_ATTR_NAMES.blank?
      assert donation.valid?, "Donation should be valid without initialisation parameters"
    else
      # If Donation has validation, then use the following:
      assert !donation.valid?, "Donation should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert donation.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    donation = Donation.new(NEW_DONATION)
    assert donation.valid?, "Donation should be valid"
   	NEW_DONATION.each do |attr_name|
      assert_equal NEW_DONATION[attr_name], donation.attributes[attr_name], "Donation.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_donation = NEW_DONATION.clone
			tmp_donation.delete attr_name.to_sym
			donation = Donation.new(tmp_donation)
			assert !donation.valid?, "Donation should be invalid, as @#{attr_name} is invalid"
    	assert donation.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_donation = Donation.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		donation = Donation.new(NEW_DONATION.merge(attr_name.to_sym => current_donation[attr_name]))
			assert !donation.valid?, "Donation should be invalid, as @#{attr_name} is a duplicate"
    	assert donation.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

