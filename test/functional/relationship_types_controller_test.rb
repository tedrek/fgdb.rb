require File.dirname(__FILE__) + '/../test_helper'
require 'relationship_types_controller'

# Re-raise errors caught by the controller.
class RelationshipTypesController; def rescue_action(e) raise e end; end

class RelationshipTypesControllerTest < Test::Unit::TestCase
  fixtures :relationship_types

  NEW_RELATIONSHIP_TYPE = {}  # e.g. {:name => 'Test RelationshipType', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = RelationshipTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = relationship_types(:first)
    @first = RelationshipType.find_first
  end

  def test_component
    get :component
    assert_response :success
    assert_template 'relationship_types/component'
    relationship_types = check_attrs(%w(relationship_types))
    assert_equal RelationshipType.find(:all).length, relationship_types.length, "Incorrect number of relationship_types shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'relationship_types/component'
    relationship_types = check_attrs(%w(relationship_types))
    assert_equal RelationshipType.find(:all).length, relationship_types.length, "Incorrect number of relationship_types shown"
  end

  def test_create
    relationship_type_count = RelationshipType.find(:all).length
    post :create, {:relationship_type => NEW_RELATIONSHIP_TYPE}
    relationship_type, successful = check_attrs(%w(relationship_type successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal relationship_type_count + 1, RelationshipType.find(:all).length, "Expected an additional RelationshipType"
  end

  def test_create_xhr
    relationship_type_count = RelationshipType.find(:all).length
    xhr :post, :create, {:relationship_type => NEW_RELATIONSHIP_TYPE}
    relationship_type, successful = check_attrs(%w(relationship_type successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal relationship_type_count + 1, RelationshipType.find(:all).length, "Expected an additional RelationshipType"
  end

  def test_update
    relationship_type_count = RelationshipType.find(:all).length
    post :update, {:id => @first.id, :relationship_type => @first.attributes.merge(NEW_RELATIONSHIP_TYPE)}
    relationship_type, successful = check_attrs(%w(relationship_type successful))
    assert successful, "Should be successful"
    relationship_type.reload
     NEW_RELATIONSHIP_TYPE.each do |attr_name|
      assert_equal NEW_RELATIONSHIP_TYPE[attr_name], relationship_type.attributes[attr_name], "@relationship_type.#{attr_name.to_s} incorrect"
    end
    assert_equal relationship_type_count, RelationshipType.find(:all).length, "Number of RelationshipTypes should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
    relationship_type_count = RelationshipType.find(:all).length
    xhr :post, :update, {:id => @first.id, :relationship_type => @first.attributes.merge(NEW_RELATIONSHIP_TYPE)}
    relationship_type, successful = check_attrs(%w(relationship_type successful))
    assert successful, "Should be successful"
    relationship_type.reload
     NEW_RELATIONSHIP_TYPE.each do |attr_name|
      assert_equal NEW_RELATIONSHIP_TYPE[attr_name], relationship_type.attributes[attr_name], "@relationship_type.#{attr_name.to_s} incorrect"
    end
    assert_equal relationship_type_count, RelationshipType.find(:all).length, "Number of RelationshipTypes should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
    relationship_type_count = RelationshipType.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal relationship_type_count - 1, RelationshipType.find(:all).length, "Number of RelationshipTypes should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
    relationship_type_count = RelationshipType.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal relationship_type_count - 1, RelationshipType.find(:all).length, "Number of RelationshipTypes should be one less"
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
