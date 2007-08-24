require File.dirname(__FILE__) + '/../test_helper'
require 'gizmo_attrs_controller'

# Re-raise errors caught by the controller.
class GizmoAttrsController; def rescue_action(e) raise e end; end

class GizmoAttrsControllerTest < Test::Unit::TestCase
  fixtures :gizmo_attrs

	NEW_GIZMO_ATTR = {}	# e.g. {:name => 'Test GizmoAttr', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = GizmoAttrsController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = gizmo_attrs(:first)
		@first = GizmoAttr.find(:first)
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'gizmo_attrs/component'
    gizmo_attrs = check_attrs(%w(gizmo_attrs))
    assert_equal GizmoAttr.find(:all).length, gizmo_attrs.length, "Incorrect number of gizmo_attrs shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'gizmo_attrs/component'
    gizmo_attrs = check_attrs(%w(gizmo_attrs))
    assert_equal GizmoAttr.find(:all).length, gizmo_attrs.length, "Incorrect number of gizmo_attrs shown"
  end

  def test_create
  	gizmo_attr_count = GizmoAttr.find(:all).length
    post :create, {:gizmo_attr => NEW_GIZMO_ATTR}
    gizmo_attr, successful = check_attrs(%w(gizmo_attr successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal gizmo_attr_count + 1, GizmoAttr.find(:all).length, "Expected an additional GizmoAttr"
  end

  def test_create_xhr
  	gizmo_attr_count = GizmoAttr.find(:all).length
    xhr :post, :create, {:gizmo_attr => NEW_GIZMO_ATTR}
    gizmo_attr, successful = check_attrs(%w(gizmo_attr successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal gizmo_attr_count + 1, GizmoAttr.find(:all).length, "Expected an additional GizmoAttr"
  end

  def test_update
  	gizmo_attr_count = GizmoAttr.find(:all).length
    post :update, {:id => @first.id, :gizmo_attr => @first.attributes.merge(NEW_GIZMO_ATTR)}
    gizmo_attr, successful = check_attrs(%w(gizmo_attr successful))
    assert successful, "Should be successful"
    gizmo_attr.reload
   	NEW_GIZMO_ATTR.each do |attr_name|
      assert_equal NEW_GIZMO_ATTR[attr_name], gizmo_attr.attributes[attr_name], "@gizmo_attr.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_attr_count, GizmoAttr.find(:all).length, "Number of GizmoAttrs should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	gizmo_attr_count = GizmoAttr.find(:all).length
    xhr :post, :update, {:id => @first.id, :gizmo_attr => @first.attributes.merge(NEW_GIZMO_ATTR)}
    gizmo_attr, successful = check_attrs(%w(gizmo_attr successful))
    assert successful, "Should be successful"
    gizmo_attr.reload
   	NEW_GIZMO_ATTR.each do |attr_name|
      assert_equal NEW_GIZMO_ATTR[attr_name], gizmo_attr.attributes[attr_name], "@gizmo_attr.#{attr_name.to_s} incorrect"
    end
    assert_equal gizmo_attr_count, GizmoAttr.find(:all).length, "Number of GizmoAttrs should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	gizmo_attr_count = GizmoAttr.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal gizmo_attr_count - 1, GizmoAttr.find(:all).length, "Number of GizmoAttrs should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	gizmo_attr_count = GizmoAttr.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal gizmo_attr_count - 1, GizmoAttr.find(:all).length, "Number of GizmoAttrs should be one less"
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
