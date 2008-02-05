require File.dirname(__FILE__) + '/../test_helper'
require 'holidays_controller'

# Re-raise errors caught by the controller.
class HolidaysController; def rescue_action(e) raise e end; end

class HolidaysControllerTest < Test::Unit::TestCase
  fixtures :holidays

  def setup
    @controller = HolidaysController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = holidays(:first).id
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

    assert_not_nil assigns(:holidays)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:holiday)
    assert assigns(:holiday).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:holiday)
  end

  def test_create
    num_holidays = Holiday.count

    post :create, :holiday => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_holidays + 1, Holiday.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:holiday)
    assert assigns(:holiday).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Holiday.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Holiday.find(@first_id)
    }
  end
end
