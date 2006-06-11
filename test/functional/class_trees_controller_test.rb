require File.dirname(__FILE__) + '/../test_helper'
require 'class_trees_controller'

# Re-raise errors caught by the controller.
class ClassTreesController; def rescue_action(e) raise e end; end

class ClassTreesControllerTest < Test::Unit::TestCase
  fixtures :class_trees

  def setup
    @controller = ClassTreesController.new
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

    assert_not_nil assigns(:class_trees)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:class_tree)
    assert assigns(:class_tree).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:class_tree)
  end

  def test_create
    num_class_trees = ClassTree.count

    post :create, :class_tree => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_class_trees + 1, ClassTree.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:class_tree)
    assert assigns(:class_tree).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ClassTree.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ClassTree.find(1)
    }
  end
end
