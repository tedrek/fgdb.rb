require File.dirname(__FILE__) + '/../test_helper'
require 'donation_lines_controller'

# Re-raise errors caught by the controller.
class DonationLinesController; def rescue_action(e) raise e end; end

class DonationLinesControllerTest < Test::Unit::TestCase
  fixtures :donation_lines

	NEW_DONATION_LINE = {}	# e.g. {:name => 'Test DonationLine', :description => 'Dummy'}
	REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

	def setup
		@controller = DonationLinesController.new
		@request    = ActionController::TestRequest.new
		@response   = ActionController::TestResponse.new
		# Retrieve fixtures via their name
		# @first = donation_lines(:first)
		@first = DonationLine.find_first
	end

  def test_component
    get :component
    assert_response :success
    assert_template 'donation_lines/component'
    donation_lines = check_attrs(%w(donation_lines))
    assert_equal DonationLine.find(:all).length, donation_lines.length, "Incorrect number of donation_lines shown"
  end

  def test_component_update
    get :component_update
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_component_update_xhr
    xhr :get, :component_update
    assert_response :success
    assert_template 'donation_lines/component'
    donation_lines = check_attrs(%w(donation_lines))
    assert_equal DonationLine.find(:all).length, donation_lines.length, "Incorrect number of donation_lines shown"
  end

  def test_create
  	donation_line_count = DonationLine.find(:all).length
    post :create, {:donation_line => NEW_DONATION_LINE}
    donation_line, successful = check_attrs(%w(donation_line successful))
    assert successful, "Should be successful"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
    assert_equal donation_line_count + 1, DonationLine.find(:all).length, "Expected an additional DonationLine"
  end

  def test_create_xhr
  	donation_line_count = DonationLine.find(:all).length
    xhr :post, :create, {:donation_line => NEW_DONATION_LINE}
    donation_line, successful = check_attrs(%w(donation_line successful))
    assert successful, "Should be successful"
    assert_response :success
    assert_template 'create.rjs'
    assert_equal donation_line_count + 1, DonationLine.find(:all).length, "Expected an additional DonationLine"
  end

  def test_update
  	donation_line_count = DonationLine.find(:all).length
    post :update, {:id => @first.id, :donation_line => @first.attributes.merge(NEW_DONATION_LINE)}
    donation_line, successful = check_attrs(%w(donation_line successful))
    assert successful, "Should be successful"
    donation_line.reload
   	NEW_DONATION_LINE.each do |attr_name|
      assert_equal NEW_DONATION_LINE[attr_name], donation_line.attributes[attr_name], "@donation_line.#{attr_name.to_s} incorrect"
    end
    assert_equal donation_line_count, DonationLine.find(:all).length, "Number of DonationLines should be the same"
    assert_response :redirect
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_update_xhr
  	donation_line_count = DonationLine.find(:all).length
    xhr :post, :update, {:id => @first.id, :donation_line => @first.attributes.merge(NEW_DONATION_LINE)}
    donation_line, successful = check_attrs(%w(donation_line successful))
    assert successful, "Should be successful"
    donation_line.reload
   	NEW_DONATION_LINE.each do |attr_name|
      assert_equal NEW_DONATION_LINE[attr_name], donation_line.attributes[attr_name], "@donation_line.#{attr_name.to_s} incorrect"
    end
    assert_equal donation_line_count, DonationLine.find(:all).length, "Number of DonationLines should be the same"
    assert_response :success
    assert_template 'update.rjs'
  end

  def test_destroy
  	donation_line_count = DonationLine.find(:all).length
    post :destroy, {:id => @first.id}
    assert_response :redirect
    assert_equal donation_line_count - 1, DonationLine.find(:all).length, "Number of DonationLines should be one less"
    assert_redirected_to REDIRECT_TO_MAIN
  end

  def test_destroy_xhr
  	donation_line_count = DonationLine.find(:all).length
    xhr :post, :destroy, {:id => @first.id}
    assert_response :success
    assert_equal donation_line_count - 1, DonationLine.find(:all).length, "Number of DonationLines should be one less"
    assert_template 'destroy.rjs'
  end

protected
	# Could be put in a Helper library and included at top of test class
  def check_attrs(attr_list)
    attrs = []
    attr_list.each do |attr_sym|
      attr = assigns(attr_sym.to_sym)
      assert_not_nil attr,       "Attribute @#{attr_sym} should not be nil"
      assert !attr.new_record?,  "Should have saved the @#{attr_sym} obj" if attr.class == ActiveRecord
      attrs << attr
    end
    attrs.length > 1 ? attrs : attrs[0]
  end
end
