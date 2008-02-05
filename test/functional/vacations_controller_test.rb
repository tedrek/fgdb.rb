require File.dirname(__FILE__) + '/../test_helper'
require 'vacations_controller'

# Re-raise errors caught by the controller.
class VacationsController; def rescue_action(e) raise e end; end

class VacationsControllerTest < Test::Unit::TestCase
  fixtures :vacations

  def setup
    @controller = VacationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = vacations(:first).id
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

    assert_not_nil assigns(:vacations)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:vacation)
    assert assigns(:vacation).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:vacation)
  end

  def test_create
    num_vacations = Vacation.count

    post :create, :vacation => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_vacations + 1, Vacation.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:vacation)
    assert assigns(:vacation).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Vacation.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Vacation.find(@first_id)
    }
  end
end
