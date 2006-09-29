require File.dirname(__FILE__) + '/../test_helper'

class SaleTxnLineTest < Test::Unit::TestCase
  fixtures :sale_txn_lines

	NEW_SALE_TXN_LINE = {}	# e.g. {:name => 'Test SaleTxnLine', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = sale_txn_lines(:first)
  end

  def test_raw_validation
    sale_txn_line = SaleTxnLine.new
    if REQ_ATTR_NAMES.blank?
      assert sale_txn_line.valid?, "SaleTxnLine should be valid without initialisation parameters"
    else
      # If SaleTxnLine has validation, then use the following:
      assert !sale_txn_line.valid?, "SaleTxnLine should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert sale_txn_line.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    sale_txn_line = SaleTxnLine.new(NEW_SALE_TXN_LINE)
    assert sale_txn_line.valid?, "SaleTxnLine should be valid"
   	NEW_SALE_TXN_LINE.each do |attr_name|
      assert_equal NEW_SALE_TXN_LINE[attr_name], sale_txn_line.attributes[attr_name], "SaleTxnLine.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_sale_txn_line = NEW_SALE_TXN_LINE.clone
			tmp_sale_txn_line.delete attr_name.to_sym
			sale_txn_line = SaleTxnLine.new(tmp_sale_txn_line)
			assert !sale_txn_line.valid?, "SaleTxnLine should be invalid, as @#{attr_name} is invalid"
    	assert sale_txn_line.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_sale_txn_line = SaleTxnLine.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		sale_txn_line = SaleTxnLine.new(NEW_SALE_TXN_LINE.merge(attr_name.to_sym => current_sale_txn_line[attr_name]))
			assert !sale_txn_line.valid?, "SaleTxnLine should be invalid, as @#{attr_name} is a duplicate"
    	assert sale_txn_line.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

