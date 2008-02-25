require File.dirname(__FILE__) + '/../test_helper'
require 'shifts_controller'

# Re-raise errors caught by the controller.
class ShiftsController; def rescue_action(e) raise e end; end

class ShiftsControllerTest < Test::Unit::TestCase
  fixtures :shifts

  def setup
    @controller = ShiftsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = shifts(:first).id
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

    assert_not_nil assigns(:shifts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:shift)
    assert assigns(:shift).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:shift)
  end

  def test_create
    num_shifts = Shift.count

    post :create, :shift => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_shifts + 1, Shift.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:shift)
    assert assigns(:shift).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Shift.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Shift.find(@first_id)
    }
  end
end
