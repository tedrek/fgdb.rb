require File.dirname(__FILE__) + '/../test_helper'
require 'weekdays_controller'

# Re-raise errors caught by the controller.
class WeekdaysController; def rescue_action(e) raise e end; end

class WeekdaysControllerTest < Test::Unit::TestCase
  fixtures :weekdays

  def setup
    @controller = WeekdaysController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = weekdays(:first).id
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

    assert_not_nil assigns(:weekdays)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:weekday)
    assert assigns(:weekday).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:weekday)
  end

  def test_create
    num_weekdays = Weekday.count

    post :create, :weekday => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_weekdays + 1, Weekday.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:weekday)
    assert assigns(:weekday).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Weekday.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Weekday.find(@first_id)
    }
  end
end
