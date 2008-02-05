require File.dirname(__FILE__) + '/../test_helper'
require 'standard_shifts_controller'

# Re-raise errors caught by the controller.
class StandardShiftsController; def rescue_action(e) raise e end; end

class StandardShiftsControllerTest < Test::Unit::TestCase
  fixtures :standard_shifts

  def setup
    @controller = StandardShiftsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = standard_shifts(:first).id
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

    assert_not_nil assigns(:standard_shifts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:standard_shift)
    assert assigns(:standard_shift).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:standard_shift)
  end

  def test_create
    num_standard_shifts = StandardShift.count

    post :create, :standard_shift => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_standard_shifts + 1, StandardShift.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:standard_shift)
    assert assigns(:standard_shift).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      StandardShift.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      StandardShift.find(@first_id)
    }
  end
end
