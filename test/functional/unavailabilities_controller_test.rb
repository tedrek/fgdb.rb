require File.dirname(__FILE__) + '/../test_helper'
require 'unavailabilities_controller'

# Re-raise errors caught by the controller.
class UnavailabilitiesController; def rescue_action(e) raise e end; end

class UnavailabilitiesControllerTest < Test::Unit::TestCase
  fixtures :unavailabilities

  def setup
    @controller = UnavailabilitiesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = unavailabilities(:first).id
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

    assert_not_nil assigns(:unavailabilities)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:unavailability)
    assert assigns(:unavailability).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:unavailability)
  end

  def test_create
    num_unavailabilities = Unavailability.count

    post :create, :unavailability => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_unavailabilities + 1, Unavailability.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:unavailability)
    assert assigns(:unavailability).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Unavailability.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Unavailability.find(@first_id)
    }
  end
end
