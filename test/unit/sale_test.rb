require File.dirname(__FILE__) + '/../test_helper'

class SaleTest < Test::Unit::TestCase
  fixtures :sales

  def test_sanity
    assert_equal 2, 1+1
  end
  
end
