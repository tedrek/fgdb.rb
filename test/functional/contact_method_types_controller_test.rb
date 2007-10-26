require File.dirname(__FILE__) + '/../test_helper'
require 'contact_method_types_controller'

# Re-raise errors caught by the controller.
class ContactMethodTypesController; def rescue_action(e) raise e end; end

class ContactMethodTypesControllerTest < Test::Unit::TestCase
  fixtures :contact_method_types

  NEW_CONTACT_METHOD_TYPE = {}  # e.g. {:name => 'Test ContactMethodType', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = ContactMethodTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = contact_method_types(:first)
    @first = ContactMethodType.find_first
  end

end
