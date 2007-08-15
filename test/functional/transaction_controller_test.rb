require File.dirname(__FILE__) + '/../test_helper'
require 'transaction_controller'

# Re-raise errors caught by the controller.
class TransactionController; def rescue_action(e) raise e end; end

class TransactionControllerTest < Test::Unit::TestCase
  def setup
    @controller = TransactionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_that_switching_contexts_should_be_okay
    get :donations
    assert_response :success
    assert_template 'transaction/listing'
    assert @response.session['donation'], 'should have a donation session entry'
    assert @response.session['donation'][:conditions], 'should have a donation-specific conditions entry'
    assert_equal 'daily', @response.session['donation'][:conditions].date_type, 'should default to daily'

    post( :component_update, {"commit"=>"Refine", "conditions"=>{"month"=>"5", "end_date"=>"2007-05-29", "start_date"=>"2007-05-22", "date"=>"2007-05-29", "payment_method_id"=>"", "date_type"=>"arbitrary", "year"=>"2007", "limit_type"=>"date range"}, "contact_searchbox_query"=>"", "action"=>"component_update", "controller"=>"transaction", "page"=>"1", "scaffold_id"=>"donation"} )
    assert_response :success
    assert_template 'transaction/component'
    assert @response.session['donation'], 'should have a donation session entry'
    assert @response.session['donation'][:conditions], 'should have a donation-specific conditions entry'
    assert_equal 'arbitrary', @response.session['donation'][:conditions].date_type, 'should become arbitrary'

    get :disbursements
    assert_response :success
    assert_template 'transaction/listing'
    assert @response.session['donation'], 'should still have a donation session entry'
    assert_equal 'arbitrary', @response.session['donation'][:conditions].date_type, 'should still be arbitrary'
    # :TODO:
    #assert @response.session['disbursement'], 'should have a disbursements session entry'
    #assert @response.session['disbursement'][:conditions], 'should have a disbursements-specific conditions entry'
    #assert_equal 'daily', @response.session['disbursement'][:conditions].date_type, 'should default to daily'
    #assert( ! content.include?('syntax error'), "page should not complain of a syntax error" )
  end
end
