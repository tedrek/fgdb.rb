require 'test_helper'

class DisktestBatchesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:disktest_batches)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_disktest_batch
    assert_difference('DisktestBatch.count') do
      post :create, :disktest_batch => { }
    end

    assert_redirected_to disktest_batch_path(assigns(:disktest_batch))
  end

  def test_should_show_disktest_batch
    get :show, :id => disktest_batches(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => disktest_batches(:one).id
    assert_response :success
  end

  def test_should_update_disktest_batch
    put :update, :id => disktest_batches(:one).id, :disktest_batch => { }
    assert_redirected_to disktest_batch_path(assigns(:disktest_batch))
  end

  def test_should_destroy_disktest_batch
    assert_difference('DisktestBatch.count', -1) do
      delete :destroy, :id => disktest_batches(:one).id
    end

    assert_redirected_to disktest_batches_path
  end
end
