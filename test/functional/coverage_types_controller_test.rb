require File.dirname(__FILE__) + '/../test_helper'
require 'coverage_types_controller'

# Re-raise errors caught by the controller.
class CoverageTypesController; def rescue_action(e) raise e end; end

class CoverageTypesControllerTest < Test::Unit::TestCase
  fixtures :coverage_types

  def setup
    @controller = CoverageTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = coverage_types(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:coverage_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:coverage_type)
    assert assigns(:coverage_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:coverage_type)
  end

  def test_create
    num_coverage_types = CoverageType.count

    post :create, :coverage_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_coverage_types + 1, CoverageType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:coverage_type)
    assert assigns(:coverage_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      CoverageType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      CoverageType.find(@first_id)
    }
  end
end
