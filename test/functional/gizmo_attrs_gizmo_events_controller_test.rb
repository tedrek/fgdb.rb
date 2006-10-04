require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_attrs_gizmo_events_controller'

# Re-raise errors caught by the controller.
class GizmoAttrsGizmoEventsController; def rescue_action(e) raise e end; end

class GizmoAttrsGizmoEventsControllerTest < Test::Unit::TestCase
  fixtures :gizmo_attrs_gizmo_events

	NEW_GIZMO_ATTRS_GIZMO_EVENT = {}	# e.g. {:name => 'Test GizmoAttrsGizmoEvent', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = GizmoAttrsGizmoEventsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = gizmo_attrs_gizmo_events(:first)
		@first = GizmoAttrsGizmoEvent.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'gizmo_attrs_gizmo_events/component'
    gizmo_attrs_gizmo_events = check_attrs(%w(gizmo_attrs_gizmo_events))
    assert_equal GizmoAttrsGizmoEvent.find(:all).length, gizmo_attrs_gizmo_events.length, "Incorrect number of gizmo_attrs_gizmo_events shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'gizmo_attrs_gizmo_events/component'
    gizmo_attrs_gizmo_events = check_attrs(%w(gizmo_attrs_gizmo_events))
    assert_equal GizmoAttrsGizmoEvent.find(:all).length, gizmo_attrs_gizmo_events.length, "Incorrect number of gizmo_attrs_gizmo_events shown"
  end

  def test_create
  	gizmo_attrs_gizmo_event_count = GizmoAttrsGizmoEvent.find(:all).length
    post :create, {:gizmo_attrs_gizmo_event => NEW_GIZMO_ATTRS_GIZMO_EVENT}
    gizmo_attrs_gizmo_event, successful = check_attrs(%w(gizmo_attrs_gizmo_event successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal gizmo_attrs_gizmo_event_count + 1, GizmoAttrsGizmoEvent.find(:all).length, "Expected an additional GizmoAttrsGizmoEvent"
  end

  def test_create_xhr
  	gizmo_attrs_gizmo_event_count = GizmoAttrsGizmoEvent.find(:all).length
    xhr :post, :create, {:gizmo_attrs_gizmo_event => NEW_GIZMO_ATTRS_GIZMO_EVENT}
    gizmo_attrs_gizmo_event, successful = check_attrs(%w(gizmo_attrs_gizmo_event successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal gizmo_attrs_gizmo_event_count + 1, GizmoAttrsGizmoEvent.find(:all).length, "Expected an additional GizmoAttrsGizmoEvent"
  end

  def test_update
  	gizmo_attrs_gizmo_event_count = GizmoAttrsGizmoEvent.find(:all).length
    post :update, {:id => @first.id, :gizmo_attrs_gizmo_event => @first.attributes.merge(NEW_GIZMO_ATTRS_GIZMO_EVENT)}
    gizmo_attrs_gizmo_event, successful = check_attrs(%w(gizmo_attrs_gizmo_event successful))
    assert successful, "Should be successful"
    gizmo_attrs_gizmo_event.reload
   	NEW_GIZMO_ATTRS_GIZMO_EVENT.each do |attr_name|
      assert_equal NEW_GIZMO_ATTRS_GIZMO_EVENT[attr_name], gizmo_attrs_gizmo_event.attributes[attr_name], "@gizmo_attrs_gizmo_event.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_attrs_gizmo_event_count, GizmoAttrsGizmoEvent.find(:all).length, "Number of GizmoAttrsGizmoEvents should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	gizmo_attrs_gizmo_event_count = GizmoAttrsGizmoEvent.find(:all).length
    xhr :post, :update, {:id => @first.id, :gizmo_attrs_gizmo_event => @first.attributes.merge(NEW_GIZMO_ATTRS_GIZMO_EVENT)}
    gizmo_attrs_gizmo_event, successful = check_attrs(%w(gizmo_attrs_gizmo_event successful))
    assert successful, "Should be successful"
    gizmo_attrs_gizmo_event.reload
   	NEW_GIZMO_ATTRS_GIZMO_EVENT.each do |attr_name|
      assert_equal NEW_GIZMO_ATTRS_GIZMO_EVENT[attr_name], gizmo_attrs_gizmo_event.attributes[attr_name], "@gizmo_attrs_gizmo_event.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_attrs_gizmo_event_count, GizmoAttrsGizmoEvent.find(:all).length, "Number of GizmoAttrsGizmoEvents should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	gizmo_attrs_gizmo_event_count = GizmoAttrsGizmoEvent.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal gizmo_attrs_gizmo_event_count - 1, GizmoAttrsGizmoEvent.find(:all).length, "Number of GizmoAttrsGizmoEvents should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	gizmo_attrs_gizmo_event_count = GizmoAttrsGizmoEvent.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal gizmo_attrs_gizmo_event_count - 1, GizmoAttrsGizmoEvent.find(:all).length, "Number of GizmoAttrsGizmoEvents should be one less"
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
