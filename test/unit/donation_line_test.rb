require File.dirname(__FILE__) + '/../test_helper'

class DonationLineTest < Test::Unit::TestCase
  fixtures :donation_lines

	NEW_DONATION_LINE = {}	# e.g. {:name => 'Test DonationLine', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = donation_lines(:first)
  end

  def test_raw_validation
    donation_line = DonationLine.new
    if REQ_ATTR_NAMES.blank?
      assert donation_line.valid?, "DonationLine should be valid without initialisation parameters"
    else
      # If DonationLine has validation, then use the following:
      assert !donation_line.valid?, "DonationLine should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert donation_line.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    donation_line = DonationLine.new(NEW_DONATION_LINE)
    assert donation_line.valid?, "DonationLine should be valid"
   	NEW_DONATION_LINE.each do |attr_name|
      assert_equal NEW_DONATION_LINE[attr_name], donation_line.attributes[attr_name], "DonationLine.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_donation_line = NEW_DONATION_LINE.clone
			tmp_donation_line.delete attr_name.to_sym
			donation_line = DonationLine.new(tmp_donation_line)
			assert !donation_line.valid?, "DonationLine should be invalid, as @#{attr_name} is invalid"
    	assert donation_line.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_donation_line = DonationLine.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		donation_line = DonationLine.new(NEW_DONATION_LINE.merge(attr_name.to_sym => current_donation_line[attr_name]))
			assert !donation_line.valid?, "DonationLine should be invalid, as @#{attr_name} is a duplicate"
    	assert donation_line.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

