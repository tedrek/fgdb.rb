require File.dirname(__FILE__) + '/../test_helper'
require 'forsale_items_controller'

# Re-raise errors caught by the controller.
class ForsaleItemsController; def rescue_action(e) raise e end; end

class ForsaleItemsControllerTest < Test::Unit::TestCase
  fixtures :forsale_items

	NEW_FORSALE_ITEM = {}	# e.g. {:name => 'Test ForsaleItem', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = ForsaleItemsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = forsale_items(:first)
		@first = ForsaleItem.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'forsale_items/component'
    forsale_items = check_attrs(%w(forsale_items))
    assert_equal ForsaleItem.find(:all).length, forsale_items.length, "Incorrect number of forsale_items shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'forsale_items/component'
    forsale_items = check_attrs(%w(forsale_items))
    assert_equal ForsaleItem.find(:all).length, forsale_items.length, "Incorrect number of forsale_items shown"
  end

  def test_create
  	forsale_item_count = ForsaleItem.find(:all).length
    post :create, {:forsale_item => NEW_FORSALE_ITEM}
    forsale_item, successful = check_attrs(%w(forsale_item successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal forsale_item_count + 1, ForsaleItem.find(:all).length, "Expected an additional ForsaleItem"
  end

  def test_create_xhr
  	forsale_item_count = ForsaleItem.find(:all).length
    xhr :post, :create, {:forsale_item => NEW_FORSALE_ITEM}
    forsale_item, successful = check_attrs(%w(forsale_item successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal forsale_item_count + 1, ForsaleItem.find(:all).length, "Expected an additional ForsaleItem"
  end

  def test_update
  	forsale_item_count = ForsaleItem.find(:all).length
    post :update, {:id => @first.id, :forsale_item => @first.attributes.merge(NEW_FORSALE_ITEM)}
    forsale_item, successful = check_attrs(%w(forsale_item successful))
    assert successful, "Should be successful"
    forsale_item.reload
   	NEW_FORSALE_ITEM.each do |attr_name|
      assert_equal NEW_FORSALE_ITEM[attr_name], forsale_item.attributes[attr_name], "@forsale_item.#{attr_name.to_s} incorrect"
    end
    assert_equal forsale_item_count, ForsaleItem.find(:all).length, "Number of ForsaleItems should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	forsale_item_count = ForsaleItem.find(:all).length
    xhr :post, :update, {:id => @first.id, :forsale_item => @first.attributes.merge(NEW_FORSALE_ITEM)}
    forsale_item, successful = check_attrs(%w(forsale_item successful))
    assert successful, "Should be successful"
    forsale_item.reload
   	NEW_FORSALE_ITEM.each do |attr_name|
      assert_equal NEW_FORSALE_ITEM[attr_name], forsale_item.attributes[attr_name], "@forsale_item.#{attr_name.to_s} incorrect"
    end
    assert_equal forsale_item_count, ForsaleItem.find(:all).length, "Number of ForsaleItems should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	forsale_item_count = ForsaleItem.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal forsale_item_count - 1, ForsaleItem.find(:all).length, "Number of ForsaleItems should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	forsale_item_count = ForsaleItem.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal forsale_item_count - 1, ForsaleItem.find(:all).length, "Number of ForsaleItems should be one less"
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
