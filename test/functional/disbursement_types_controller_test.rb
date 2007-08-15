require File.dirname(__FILE__) + '/../test_helper'
require 'disbursement_types_controller'

# Re-raise errors caught by the controller.
class DisbursementTypesController; def rescue_action(e) raise e end; end

class DisbursementTypesControllerTest < Test::Unit::TestCase
  fixtures :disbursement_types

  def setup
    @controller = DisbursementTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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

    assert_not_nil assigns(:disbursement_types)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:disbursement_type)
    assert assigns(:disbursement_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:disbursement_type)
  end

  def test_create
    num_disbursement_types = DisbursementType.count

    post :create, :disbursement_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_disbursement_types + 1, DisbursementType.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:disbursement_type)
    assert assigns(:disbursement_type).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil DisbursementType.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      DisbursementType.find(1)
    }
  end
end
