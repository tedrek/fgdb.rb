require File.dirname(__FILE__) + '/../test_helper'
require 'work_shifts_controller'

# Re-raise errors caught by the controller.
class WorkShiftsController; def rescue_action(e) raise e end; end

class WorkShiftsControllerTest < Test::Unit::TestCase
  fixtures :work_shifts

  def setup
    @controller = WorkShiftsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = work_shifts(:first).id
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

    assert_not_nil assigns(:work_shifts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:work_shift)
    assert assigns(:work_shift).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:work_shift)
  end

  def test_create
    num_work_shifts = WorkShift.count

    post :create, :work_shift => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_work_shifts + 1, WorkShift.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:work_shift)
    assert assigns(:work_shift).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      WorkShift.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      WorkShift.find(@first_id)
    }
  end
end
