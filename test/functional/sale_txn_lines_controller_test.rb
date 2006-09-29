require File.dirname(__FILE__) + '/../test_helper'
require 'sale_txn_lines_controller'

# Re-raise errors caught by the controller.
class SaleTxnLinesController; def rescue_action(e) raise e end; end

class SaleTxnLinesControllerTest < Test::Unit::TestCase
  fixtures :sale_txn_lines

	NEW_SALE_TXN_LINE = {}	# e.g. {:name => 'Test SaleTxnLine', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = SaleTxnLinesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = sale_txn_lines(:first)
		@first = SaleTxnLine.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'sale_txn_lines/component'
    sale_txn_lines = check_attrs(%w(sale_txn_lines))
    assert_equal SaleTxnLine.find(:all).length, sale_txn_lines.length, "Incorrect number of sale_txn_lines shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'sale_txn_lines/component'
    sale_txn_lines = check_attrs(%w(sale_txn_lines))
    assert_equal SaleTxnLine.find(:all).length, sale_txn_lines.length, "Incorrect number of sale_txn_lines shown"
  end

  def test_create
  	sale_txn_line_count = SaleTxnLine.find(:all).length
    post :create, {:sale_txn_line => NEW_SALE_TXN_LINE}
    sale_txn_line, successful = check_attrs(%w(sale_txn_line successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal sale_txn_line_count + 1, SaleTxnLine.find(:all).length, "Expected an additional SaleTxnLine"
  end

  def test_create_xhr
  	sale_txn_line_count = SaleTxnLine.find(:all).length
    xhr :post, :create, {:sale_txn_line => NEW_SALE_TXN_LINE}
    sale_txn_line, successful = check_attrs(%w(sale_txn_line successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal sale_txn_line_count + 1, SaleTxnLine.find(:all).length, "Expected an additional SaleTxnLine"
  end

  def test_update
  	sale_txn_line_count = SaleTxnLine.find(:all).length
    post :update, {:id => @first.id, :sale_txn_line => @first.attributes.merge(NEW_SALE_TXN_LINE)}
    sale_txn_line, successful = check_attrs(%w(sale_txn_line successful))
    assert successful, "Should be successful"
    sale_txn_line.reload
   	NEW_SALE_TXN_LINE.each do |attr_name|
      assert_equal NEW_SALE_TXN_LINE[attr_name], sale_txn_line.attributes[attr_name], "@sale_txn_line.#{attr_name.to_s} incorrect"
    end
    assert_equal sale_txn_line_count, SaleTxnLine.find(:all).length, "Number of SaleTxnLines should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	sale_txn_line_count = SaleTxnLine.find(:all).length
    xhr :post, :update, {:id => @first.id, :sale_txn_line => @first.attributes.merge(NEW_SALE_TXN_LINE)}
    sale_txn_line, successful = check_attrs(%w(sale_txn_line successful))
    assert successful, "Should be successful"
    sale_txn_line.reload
   	NEW_SALE_TXN_LINE.each do |attr_name|
      assert_equal NEW_SALE_TXN_LINE[attr_name], sale_txn_line.attributes[attr_name], "@sale_txn_line.#{attr_name.to_s} incorrect"
    end
    assert_equal sale_txn_line_count, SaleTxnLine.find(:all).length, "Number of SaleTxnLines should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	sale_txn_line_count = SaleTxnLine.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal sale_txn_line_count - 1, SaleTxnLine.find(:all).length, "Number of SaleTxnLines should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	sale_txn_line_count = SaleTxnLine.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal sale_txn_line_count - 1, SaleTxnLine.find(:all).length, "Number of SaleTxnLines should be one less"
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
