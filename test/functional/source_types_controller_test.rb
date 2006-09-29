require File.dirname(__FILE__) + '/../test_helper'
require 'source_types_controller'

# Re-raise errors caught by the controller.
class SourceTypesController; def rescue_action(e) raise e end; end

class SourceTypesControllerTest < Test::Unit::TestCase
  fixtures :source_types

	NEW_SOURCE_TYPE = {}	# e.g. {:name => 'Test SourceType', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = SourceTypesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = source_types(:first)
		@first = SourceType.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'source_types/component'
    source_types = check_attrs(%w(source_types))
    assert_equal SourceType.find(:all).length, source_types.length, "Incorrect number of source_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'source_types/component'
    source_types = check_attrs(%w(source_types))
    assert_equal SourceType.find(:all).length, source_types.length, "Incorrect number of source_types shown"
  end

  def test_create
  	source_type_count = SourceType.find(:all).length
    post :create, {:source_type => NEW_SOURCE_TYPE}
    source_type, successful = check_attrs(%w(source_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal source_type_count + 1, SourceType.find(:all).length, "Expected an additional SourceType"
  end

  def test_create_xhr
  	source_type_count = SourceType.find(:all).length
    xhr :post, :create, {:source_type => NEW_SOURCE_TYPE}
    source_type, successful = check_attrs(%w(source_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal source_type_count + 1, SourceType.find(:all).length, "Expected an additional SourceType"
  end

  def test_update
  	source_type_count = SourceType.find(:all).length
    post :update, {:id => @first.id, :source_type => @first.attributes.merge(NEW_SOURCE_TYPE)}
    source_type, successful = check_attrs(%w(source_type successful))
    assert successful, "Should be successful"
    source_type.reload
   	NEW_SOURCE_TYPE.each do |attr_name|
      assert_equal NEW_SOURCE_TYPE[attr_name], source_type.attributes[attr_name], "@source_type.#{attr_name.to_s} incorrect"
    end
    assert_equal source_type_count, SourceType.find(:all).length, "Number of SourceTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	source_type_count = SourceType.find(:all).length
    xhr :post, :update, {:id => @first.id, :source_type => @first.attributes.merge(NEW_SOURCE_TYPE)}
    source_type, successful = check_attrs(%w(source_type successful))
    assert successful, "Should be successful"
    source_type.reload
   	NEW_SOURCE_TYPE.each do |attr_name|
      assert_equal NEW_SOURCE_TYPE[attr_name], source_type.attributes[attr_name], "@source_type.#{attr_name.to_s} incorrect"
    end
    assert_equal source_type_count, SourceType.find(:all).length, "Number of SourceTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	source_type_count = SourceType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal source_type_count - 1, SourceType.find(:all).length, "Number of SourceTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	source_type_count = SourceType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal source_type_count - 1, SourceType.find(:all).length, "Number of SourceTypes should be one less"
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
