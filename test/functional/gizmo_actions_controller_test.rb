require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_actions_controller'

# Re-raise errors caught by the controller.
class GizmoActionsController; def rescue_action(e) raise e end; end

class GizmoActionsControllerTest < Test::Unit::TestCase
  fixtures :gizmo_actions

	NEW_GIZMO_ACTION = {}	# e.g. {:name => 'Test GizmoAction', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = GizmoActionsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = gizmo_actions(:first)
		@first = GizmoAction.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'gizmo_actions/component'
    gizmo_actions = check_attrs(%w(gizmo_actions))
    assert_equal GizmoAction.find(:all).length, gizmo_actions.length, "Incorrect number of gizmo_actions shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'gizmo_actions/component'
    gizmo_actions = check_attrs(%w(gizmo_actions))
    assert_equal GizmoAction.find(:all).length, gizmo_actions.length, "Incorrect number of gizmo_actions shown"
  end

  def test_create
  	gizmo_action_count = GizmoAction.find(:all).length
    post :create, {:gizmo_action => NEW_GIZMO_ACTION}
    gizmo_action, successful = check_attrs(%w(gizmo_action successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal gizmo_action_count + 1, GizmoAction.find(:all).length, "Expected an additional GizmoAction"
  end

  def test_create_xhr
  	gizmo_action_count = GizmoAction.find(:all).length
    xhr :post, :create, {:gizmo_action => NEW_GIZMO_ACTION}
    gizmo_action, successful = check_attrs(%w(gizmo_action successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal gizmo_action_count + 1, GizmoAction.find(:all).length, "Expected an additional GizmoAction"
  end

  def test_update
  	gizmo_action_count = GizmoAction.find(:all).length
    post :update, {:id => @first.id, :gizmo_action => @first.attributes.merge(NEW_GIZMO_ACTION)}
    gizmo_action, successful = check_attrs(%w(gizmo_action successful))
    assert successful, "Should be successful"
    gizmo_action.reload
   	NEW_GIZMO_ACTION.each do |attr_name|
      assert_equal NEW_GIZMO_ACTION[attr_name], gizmo_action.attributes[attr_name], "@gizmo_action.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_action_count, GizmoAction.find(:all).length, "Number of GizmoActions should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	gizmo_action_count = GizmoAction.find(:all).length
    xhr :post, :update, {:id => @first.id, :gizmo_action => @first.attributes.merge(NEW_GIZMO_ACTION)}
    gizmo_action, successful = check_attrs(%w(gizmo_action successful))
    assert successful, "Should be successful"
    gizmo_action.reload
   	NEW_GIZMO_ACTION.each do |attr_name|
      assert_equal NEW_GIZMO_ACTION[attr_name], gizmo_action.attributes[attr_name], "@gizmo_action.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_action_count, GizmoAction.find(:all).length, "Number of GizmoActions should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	gizmo_action_count = GizmoAction.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal gizmo_action_count - 1, GizmoAction.find(:all).length, "Number of GizmoActions should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	gizmo_action_count = GizmoAction.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal gizmo_action_count - 1, GizmoAction.find(:all).length, "Number of GizmoActions should be one less"
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
