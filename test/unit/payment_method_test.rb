require File.dirname(__FILE__) + '/../test_helper'

class PaymentMethodTest < ActiveSupport::TestCase
  fixtures :payment_methods

  NEW_PAYMENT_METHOD = {}	# e.g. {:name => 'Test PaymentMethod', :description => 'Dummy'}
  REQ_ATTR_NAMES 			 = %w( ) # name of fields that must be present, e.g. %(name description)
  DUPLICATE_ATTR_NAMES = %w( ) # name of fields that cannot be a duplicate, e.g. %(name description)

  def setup
    # Retrieve fixtures via their name
    # @first = payment_methods(:first)
  end

  def test_raw_validation
    payment_method = PaymentMethod.new
    if REQ_ATTR_NAMES.blank?
      assert payment_method.valid?, "PaymentMethod should be valid without initialisation parameters"
    else
      # If PaymentMethod has validation, then use the following:
      assert !payment_method.valid?, "PaymentMethod should not be valid without initialisation parameters"
      REQ_ATTR_NAMES.each do |attr_name|
        assert(payment_method.errors[attr_name.to_sym].any?,
               "Should be an error message for :#{attr_name}")
      end
    end
  end

  def test_new
    payment_method = PaymentMethod.new(NEW_PAYMENT_METHOD)
    assert payment_method.valid?, "PaymentMethod should be valid"
    NEW_PAYMENT_METHOD.each do |attr_name|
      assert_equal NEW_PAYMENT_METHOD[attr_name], payment_method.attributes[attr_name], "PaymentMethod.@#{attr_name.to_s} incorrect"
    end
  end

  def test_validates_presence_of
    REQ_ATTR_NAMES.each do |attr_name|
      tmp_payment_method = NEW_PAYMENT_METHOD.clone
      tmp_payment_method.delete attr_name.to_sym
      payment_method = PaymentMethod.new(tmp_payment_method)
      assert !payment_method.valid?, "PaymentMethod should be invalid, as @#{attr_name} is invalid"
      assert(payment_method.errors[attr_name.to_sym].any?,
             "Should be an error message for :#{attr_name}")
    end
  end

  def test_duplicate
    current_payment_method = PaymentMethod.find(:first)
    DUPLICATE_ATTR_NAMES.each do |attr_name|
      payment_method = PaymentMethod.new(NEW_PAYMENT_METHOD.merge(attr_name.to_sym => current_payment_method[attr_name]))
      assert !payment_method.valid?, "PaymentMethod should be invalid, as @#{attr_name} is a duplicate"
      assert(payment_method.errors[attr_name.to_sym].any?,
             "Should be an error message for :#{attr_name}")
    end
  end
end
