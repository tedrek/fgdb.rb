require File.dirname(__FILE__) + '/../test_helper'
require 'donated_gizmos_controller'

# Re-raise errors caught by the controller.
class DonatedGizmosController; def rescue_action(e) raise e end; end

class DonatedGizmosControllerTest < Test::Unit::TestCase
  fixtures :donated_gizmos

	NEW_DONATED_GIZMO = {}	# e.g. {:name => 'Test DonatedGizmo', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DonatedGizmosController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = donated_gizmos(:first)
		@first = DonatedGizmo.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'donated_gizmos/component'
    donated_gizmos = check_attrs(%w(donated_gizmos))
    assert_equal DonatedGizmo.find(:all).length, donated_gizmos.length, "Incorrect number of donated_gizmos shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'donated_gizmos/component'
    donated_gizmos = check_attrs(%w(donated_gizmos))
    assert_equal DonatedGizmo.find(:all).length, donated_gizmos.length, "Incorrect number of donated_gizmos shown"
  end

  def test_create
  	donated_gizmo_count = DonatedGizmo.find(:all).length
    post :create, {:donated_gizmo => NEW_DONATED_GIZMO}
    donated_gizmo, successful = check_attrs(%w(donated_gizmo successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal donated_gizmo_count + 1, DonatedGizmo.find(:all).length, "Expected an additional DonatedGizmo"
  end

  def test_create_xhr
  	donated_gizmo_count = DonatedGizmo.find(:all).length
    xhr :post, :create, {:donated_gizmo => NEW_DONATED_GIZMO}
    donated_gizmo, successful = check_attrs(%w(donated_gizmo successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal donated_gizmo_count + 1, DonatedGizmo.find(:all).length, "Expected an additional DonatedGizmo"
  end

  def test_update
  	donated_gizmo_count = DonatedGizmo.find(:all).length
    post :update, {:id => @first.id, :donated_gizmo => @first.attributes.merge(NEW_DONATED_GIZMO)}
    donated_gizmo, successful = check_attrs(%w(donated_gizmo successful))
    assert successful, "Should be successful"
    donated_gizmo.reload
   	NEW_DONATED_GIZMO.each do |attr_name|
      assert_equal NEW_DONATED_GIZMO[attr_name], donated_gizmo.attributes[attr_name], "@donated_gizmo.#{attr_name.to_s} incorrect"
    end
    assert_equal donated_gizmo_count, DonatedGizmo.find(:all).length, "Number of DonatedGizmos should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	donated_gizmo_count = DonatedGizmo.find(:all).length
    xhr :post, :update, {:id => @first.id, :donated_gizmo => @first.attributes.merge(NEW_DONATED_GIZMO)}
    donated_gizmo, successful = check_attrs(%w(donated_gizmo successful))
    assert successful, "Should be successful"
    donated_gizmo.reload
   	NEW_DONATED_GIZMO.each do |attr_name|
      assert_equal NEW_DONATED_GIZMO[attr_name], donated_gizmo.attributes[attr_name], "@donated_gizmo.#{attr_name.to_s} incorrect"
    end
    assert_equal donated_gizmo_count, DonatedGizmo.find(:all).length, "Number of DonatedGizmos should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	donated_gizmo_count = DonatedGizmo.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal donated_gizmo_count - 1, DonatedGizmo.find(:all).length, "Number of DonatedGizmos should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	donated_gizmo_count = DonatedGizmo.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal donated_gizmo_count - 1, DonatedGizmo.find(:all).length, "Number of DonatedGizmos should be one less"
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
