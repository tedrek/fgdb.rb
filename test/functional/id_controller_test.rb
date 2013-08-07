require 'test_helper'

class IdControllerTest < ActionController::TestCase
  fixtures :contacts

  test "the index" do
    get :index
    assert_response :success
  end

  test "a lookup" do
    get :lookup, :first_name => 'Charles', :surname => 'McGeneneen'
    assert_response :success
    assert_not_nil assigns['contact']
    assert_equal assigns['contact'].id, 17, 'Found the right contact'
  end

  test "a non-existent lookup" do
    get :lookup, :first_name => 'Santa', :surname => 'Claus'
    assert_response :success
    assert_nil assigns['contact']
  end
end
