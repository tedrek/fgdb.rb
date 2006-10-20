require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_events_gizmo_typeattrs_controller'

# Re-raise errors caught by the controller.
class GizmoEventsGizmoTypeattrsController; def rescue_action(e) raise e end; end

class GizmoEventsGizmoTypeattrsControllerTest < Test::Unit::TestCase
  fixtures :gizmo_events_gizmo_typeattrs

	NEW_GIZMO_EVENTS_GIZMO_TYPEATTR = {}	# e.g. {:name => 'Test GizmoEventsGizmoTypeattr', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = GizmoEventsGizmoTypeattrsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = gizmo_events_gizmo_typeattrs(:first)
		@first = GizmoEventsGizmoTypeattr.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'gizmo_events_gizmo_typeattrs/component'
    gizmo_events_gizmo_typeattrs = check_attrs(%w(gizmo_events_gizmo_typeattrs))
    assert_equal GizmoEventsGizmoTypeattr.find(:all).length, gizmo_events_gizmo_typeattrs.length, "Incorrect number of gizmo_events_gizmo_typeattrs shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'gizmo_events_gizmo_typeattrs/component'
    gizmo_events_gizmo_typeattrs = check_attrs(%w(gizmo_events_gizmo_typeattrs))
    assert_equal GizmoEventsGizmoTypeattr.find(:all).length, gizmo_events_gizmo_typeattrs.length, "Incorrect number of gizmo_events_gizmo_typeattrs shown"
  end

  def test_create
  	gizmo_events_gizmo_typeattr_count = GizmoEventsGizmoTypeattr.find(:all).length
    post :create, {:gizmo_events_gizmo_typeattr => NEW_GIZMO_EVENTS_GIZMO_TYPEATTR}
    gizmo_events_gizmo_typeattr, successful = check_attrs(%w(gizmo_events_gizmo_typeattr successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal gizmo_events_gizmo_typeattr_count + 1, GizmoEventsGizmoTypeattr.find(:all).length, "Expected an additional GizmoEventsGizmoTypeattr"
  end

  def test_create_xhr
  	gizmo_events_gizmo_typeattr_count = GizmoEventsGizmoTypeattr.find(:all).length
    xhr :post, :create, {:gizmo_events_gizmo_typeattr => NEW_GIZMO_EVENTS_GIZMO_TYPEATTR}
    gizmo_events_gizmo_typeattr, successful = check_attrs(%w(gizmo_events_gizmo_typeattr successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal gizmo_events_gizmo_typeattr_count + 1, GizmoEventsGizmoTypeattr.find(:all).length, "Expected an additional GizmoEventsGizmoTypeattr"
  end

  def test_update
  	gizmo_events_gizmo_typeattr_count = GizmoEventsGizmoTypeattr.find(:all).length
    post :update, {:id => @first.id, :gizmo_events_gizmo_typeattr => @first.attributes.merge(NEW_GIZMO_EVENTS_GIZMO_TYPEATTR)}
    gizmo_events_gizmo_typeattr, successful = check_attrs(%w(gizmo_events_gizmo_typeattr successful))
    assert successful, "Should be successful"
    gizmo_events_gizmo_typeattr.reload
   	NEW_GIZMO_EVENTS_GIZMO_TYPEATTR.each do |attr_name|
      assert_equal NEW_GIZMO_EVENTS_GIZMO_TYPEATTR[attr_name], gizmo_events_gizmo_typeattr.attributes[attr_name], "@gizmo_events_gizmo_typeattr.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_events_gizmo_typeattr_count, GizmoEventsGizmoTypeattr.find(:all).length, "Number of GizmoEventsGizmoTypeattrs should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	gizmo_events_gizmo_typeattr_count = GizmoEventsGizmoTypeattr.find(:all).length
    xhr :post, :update, {:id => @first.id, :gizmo_events_gizmo_typeattr => @first.attributes.merge(NEW_GIZMO_EVENTS_GIZMO_TYPEATTR)}
    gizmo_events_gizmo_typeattr, successful = check_attrs(%w(gizmo_events_gizmo_typeattr successful))
    assert successful, "Should be successful"
    gizmo_events_gizmo_typeattr.reload
   	NEW_GIZMO_EVENTS_GIZMO_TYPEATTR.each do |attr_name|
      assert_equal NEW_GIZMO_EVENTS_GIZMO_TYPEATTR[attr_name], gizmo_events_gizmo_typeattr.attributes[attr_name], "@gizmo_events_gizmo_typeattr.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_events_gizmo_typeattr_count, GizmoEventsGizmoTypeattr.find(:all).length, "Number of GizmoEventsGizmoTypeattrs should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	gizmo_events_gizmo_typeattr_count = GizmoEventsGizmoTypeattr.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal gizmo_events_gizmo_typeattr_count - 1, GizmoEventsGizmoTypeattr.find(:all).length, "Number of GizmoEventsGizmoTypeattrs should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	gizmo_events_gizmo_typeattr_count = GizmoEventsGizmoTypeattr.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal gizmo_events_gizmo_typeattr_count - 1, GizmoEventsGizmoTypeattr.find(:all).length, "Number of GizmoEventsGizmoTypeattrs should be one less"
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
