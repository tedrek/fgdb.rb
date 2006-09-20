require File.dirname(__FILE__) + '/../test_helper'
require 'relationships_controller'

# Re-raise errors caught by the controller.
class RelationshipsController; def rescue_action(e) raise e end; end

class RelationshipsControllerTest < Test::Unit::TestCase
  fixtures :relationships

  NEW_RELATIONSHIP = {}  # e.g. {:name => 'Test Relationship', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = RelationshipsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = relationships(:first)
    @first = Relationship.find_first
  end

  def test_component
    get :component
    assert_response :success
    assert_template 'relationships/component'
    relationships = check_attrs(%w(relationships))
    assert_equal Relationship.find(:all).length, relationships.length, "Incorrect number of relationships shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'relationships/component'
    relationships = check_attrs(%w(relationships))
    assert_equal Relationship.find(:all).length, relationships.length, "Incorrect number of relationships shown"
  end

  def test_create
    relationship_count = Relationship.find(:all).length
    post :create, {:relationship => NEW_RELATIONSHIP}
    relationship, successful = check_attrs(%w(relationship successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal relationship_count + 1, Relationship.find(:all).length, "Expected an additional Relationship"
  end

  def test_create_xhr
    relationship_count = Relationship.find(:all).length
    xhr :post, :create, {:relationship => NEW_RELATIONSHIP}
    relationship, successful = check_attrs(%w(relationship successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal relationship_count + 1, Relationship.find(:all).length, "Expected an additional Relationship"
  end

  def test_update
    relationship_count = Relationship.find(:all).length
    post :update, {:id => @first.id, :relationship => @first.attributes.merge(NEW_RELATIONSHIP)}
    relationship, successful = check_attrs(%w(relationship successful))
    assert successful, "Should be successful"
    relationship.reload
     NEW_RELATIONSHIP.each do |attr_name|
      assert_equal NEW_RELATIONSHIP[attr_name], relationship.attributes[attr_name], "@relationship.#{attr_name.to_s} incorrect"
    end
    assert_equal relationship_count, Relationship.find(:all).length, "Number of Relationships should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
    relationship_count = Relationship.find(:all).length
    xhr :post, :update, {:id => @first.id, :relationship => @first.attributes.merge(NEW_RELATIONSHIP)}
    relationship, successful = check_attrs(%w(relationship successful))
    assert successful, "Should be successful"
    relationship.reload
     NEW_RELATIONSHIP.each do |attr_name|
      assert_equal NEW_RELATIONSHIP[attr_name], relationship.attributes[attr_name], "@relationship.#{attr_name.to_s} incorrect"
    end
    assert_equal relationship_count, Relationship.find(:all).length, "Number of Relationships should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
    relationship_count = Relationship.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal relationship_count - 1, Relationship.find(:all).length, "Number of Relationships should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
    relationship_count = Relationship.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal relationship_count - 1, Relationship.find(:all).length, "Number of Relationships should be one less"
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
