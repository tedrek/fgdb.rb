require File.dirname(__FILE__) + '/../test_helper'
require 'rr_sets_controller'

# Re-raise errors caught by the controller.
class RrSetsController; def rescue_action(e) raise e end; end

class RrSetsControllerTest < Test::Unit::TestCase
  fixtures :rr_sets

  def setup
    @controller = RrSetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rr_sets(:first).id
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

    assert_not_nil assigns(:rr_sets)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rr_set)
    assert assigns(:rr_set).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rr_set)
  end

  def test_create
    num_rr_sets = RrSet.count

    post :create, :rr_set => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rr_sets + 1, RrSet.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rr_set)
    assert assigns(:rr_set).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RrSet.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RrSet.find(@first_id)
    }
  end
end
