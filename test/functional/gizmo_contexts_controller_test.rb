require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_contexts_controller'

# Re-raise errors caught by the controller.
class GizmoContextsController; def rescue_action(e) raise e end; end

class GizmoContextsControllerTest < Test::Unit::TestCase
  fixtures :gizmo_contexts

	NEW_GIZMO_CONTEXT = {}	# e.g. {:name => 'Test GizmoContext', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = GizmoContextsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = gizmo_contexts(:first)
		@first = GizmoContext.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'gizmo_contexts/component'
    gizmo_contexts = check_attrs(%w(gizmo_contexts))
    assert_equal GizmoContext.find(:all).length, gizmo_contexts.length, "Incorrect number of gizmo_contexts shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'gizmo_contexts/component'
    gizmo_contexts = check_attrs(%w(gizmo_contexts))
    assert_equal GizmoContext.find(:all).length, gizmo_contexts.length, "Incorrect number of gizmo_contexts shown"
  end

  def test_create
  	gizmo_context_count = GizmoContext.find(:all).length
    post :create, {:gizmo_context => NEW_GIZMO_CONTEXT}
    gizmo_context, successful = check_attrs(%w(gizmo_context successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal gizmo_context_count + 1, GizmoContext.find(:all).length, "Expected an additional GizmoContext"
  end

  def test_create_xhr
  	gizmo_context_count = GizmoContext.find(:all).length
    xhr :post, :create, {:gizmo_context => NEW_GIZMO_CONTEXT}
    gizmo_context, successful = check_attrs(%w(gizmo_context successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal gizmo_context_count + 1, GizmoContext.find(:all).length, "Expected an additional GizmoContext"
  end

  def test_update
  	gizmo_context_count = GizmoContext.find(:all).length
    post :update, {:id => @first.id, :gizmo_context => @first.attributes.merge(NEW_GIZMO_CONTEXT)}
    gizmo_context, successful = check_attrs(%w(gizmo_context successful))
    assert successful, "Should be successful"
    gizmo_context.reload
   	NEW_GIZMO_CONTEXT.each do |attr_name|
      assert_equal NEW_GIZMO_CONTEXT[attr_name], gizmo_context.attributes[attr_name], "@gizmo_context.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_context_count, GizmoContext.find(:all).length, "Number of GizmoContexts should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	gizmo_context_count = GizmoContext.find(:all).length
    xhr :post, :update, {:id => @first.id, :gizmo_context => @first.attributes.merge(NEW_GIZMO_CONTEXT)}
    gizmo_context, successful = check_attrs(%w(gizmo_context successful))
    assert successful, "Should be successful"
    gizmo_context.reload
   	NEW_GIZMO_CONTEXT.each do |attr_name|
      assert_equal NEW_GIZMO_CONTEXT[attr_name], gizmo_context.attributes[attr_name], "@gizmo_context.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_context_count, GizmoContext.find(:all).length, "Number of GizmoContexts should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	gizmo_context_count = GizmoContext.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal gizmo_context_count - 1, GizmoContext.find(:all).length, "Number of GizmoContexts should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	gizmo_context_count = GizmoContext.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal gizmo_context_count - 1, GizmoContext.find(:all).length, "Number of GizmoContexts should be one less"
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
