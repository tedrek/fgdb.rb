require 'test_helper'

class BarcodeControllerTest < ActionController::TestCase
  test "generating a barcode" do
    get :barcode, :id => '42', :format => :gif
    assert_response :success
  end
end
