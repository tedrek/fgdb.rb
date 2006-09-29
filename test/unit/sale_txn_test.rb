require File.dirname(__FILE__) + '/../test_helper'

class SaleTxnTest < Test::Unit::TestCase
  fixtures :sale_txns

	NEW_SALE_TXN = {}	# e.g. {:name => 'Test SaleTxn', :description => 'Dummy'}
	REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
	DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = sale_txns(:first)
  end

  def test_raw_validation
    sale_txn = SaleTxn.new
    if REQ_ATTR_NAMES.blank?
      assert sale_txn.valid?, "SaleTxn should be valid without initialisation parameters"
    else
      # If SaleTxn has validation, then use the following:
      assert !sale_txn.valid?, "SaleTxn should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each {|attr_name| assert sale_txn.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"}
    end
  end

	def test_new
    sale_txn = SaleTxn.new(NEW_SALE_TXN)
    assert sale_txn.valid?, "SaleTxn should be valid"
   	NEW_SALE_TXN.each do |attr_name|
      assert_equal NEW_SALE_TXN[attr_name], sale_txn.attributes[attr_name], "SaleTxn.@#{attr_name.to_s} incorrect"
    end
 	end

	def test_validates_presence_of
   	REQ_ATTR_NAMES.each do |attr_name|
			tmp_sale_txn = NEW_SALE_TXN.clone
			tmp_sale_txn.delete attr_name.to_sym
			sale_txn = SaleTxn.new(tmp_sale_txn)
			assert !sale_txn.valid?, "SaleTxn should be invalid, as @#{attr_name} is invalid"
    	assert sale_txn.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
    end
 	end

	def test_duplicate
    current_sale_txn = SaleTxn.find_first
   	DUPLICATE_ATTR_NAMES.each do |attr_name|
   		sale_txn = SaleTxn.new(NEW_SALE_TXN.merge(attr_name.to_sym => current_sale_txn[attr_name]))
			assert !sale_txn.valid?, "SaleTxn should be invalid, as @#{attr_name} is a duplicate"
    	assert sale_txn.errors.invalid?(attr_name.to_sym), "Should be an error message for :#{attr_name}"
		end
	end
end

