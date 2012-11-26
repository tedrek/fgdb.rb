require 'test_helper'

class RecyclingShipmentsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:recycling_shipments)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_recycling_shipment
    assert_difference('RecyclingShipment.count') do
      post :create, :recycling_shipment => { }
    end

    assert_redirected_to recycling_shipment_path(assigns(:recycling_shipment))
  end

  def test_should_show_recycling_shipment
    get :show, :id => recycling_shipments(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => recycling_shipments(:one).id
    assert_response :success
  end

  def test_should_update_recycling_shipment
    put :update, :id => recycling_shipments(:one).id, :recycling_shipment => { }
    assert_redirected_to recycling_shipment_path(assigns(:recycling_shipment))
  end

  def test_should_destroy_recycling_shipment
    assert_difference('RecyclingShipment.count', -1) do
      delete :destroy, :id => recycling_shipments(:one).id
    end

    assert_redirected_to recycling_shipments_path
  end
end
