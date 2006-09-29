require File.dirname(__FILE__) + '/../test_helper'
require 'sale_txns_controller'

# Re-raise errors caught by the controller.
class SaleTxnsController; def rescue_action(e) raise e end; end

class SaleTxnsControllerTest < Test::Unit::TestCase
  fixtures :sale_txns

	NEW_SALE_TXN = {}	# e.g. {:name => 'Test SaleTxn', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = SaleTxnsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = sale_txns(:first)
		@first = SaleTxn.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'sale_txns/component'
    sale_txns = check_attrs(%w(sale_txns))
    assert_equal SaleTxn.find(:all).length, sale_txns.length, "Incorrect number of sale_txns shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'sale_txns/component'
    sale_txns = check_attrs(%w(sale_txns))
    assert_equal SaleTxn.find(:all).length, sale_txns.length, "Incorrect number of sale_txns shown"
  end

  def test_create
  	sale_txn_count = SaleTxn.find(:all).length
    post :create, {:sale_txn => NEW_SALE_TXN}
    sale_txn, successful = check_attrs(%w(sale_txn successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal sale_txn_count + 1, SaleTxn.find(:all).length, "Expected an additional SaleTxn"
  end

  def test_create_xhr
  	sale_txn_count = SaleTxn.find(:all).length
    xhr :post, :create, {:sale_txn => NEW_SALE_TXN}
    sale_txn, successful = check_attrs(%w(sale_txn successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal sale_txn_count + 1, SaleTxn.find(:all).length, "Expected an additional SaleTxn"
  end

  def test_update
  	sale_txn_count = SaleTxn.find(:all).length
    post :update, {:id => @first.id, :sale_txn => @first.attributes.merge(NEW_SALE_TXN)}
    sale_txn, successful = check_attrs(%w(sale_txn successful))
    assert successful, "Should be successful"
    sale_txn.reload
   	NEW_SALE_TXN.each do |attr_name|
      assert_equal NEW_SALE_TXN[attr_name], sale_txn.attributes[attr_name], "@sale_txn.#{attr_name.to_s} incorrect"
    end
    assert_equal sale_txn_count, SaleTxn.find(:all).length, "Number of SaleTxns should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	sale_txn_count = SaleTxn.find(:all).length
    xhr :post, :update, {:id => @first.id, :sale_txn => @first.attributes.merge(NEW_SALE_TXN)}
    sale_txn, successful = check_attrs(%w(sale_txn successful))
    assert successful, "Should be successful"
    sale_txn.reload
   	NEW_SALE_TXN.each do |attr_name|
      assert_equal NEW_SALE_TXN[attr_name], sale_txn.attributes[attr_name], "@sale_txn.#{attr_name.to_s} incorrect"
    end
    assert_equal sale_txn_count, SaleTxn.find(:all).length, "Number of SaleTxns should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	sale_txn_count = SaleTxn.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal sale_txn_count - 1, SaleTxn.find(:all).length, "Number of SaleTxns should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	sale_txn_count = SaleTxn.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal sale_txn_count - 1, SaleTxn.find(:all).length, "Number of SaleTxns should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
