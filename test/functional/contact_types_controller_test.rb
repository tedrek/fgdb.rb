require File.dirname(__FILE__) + '/../test_helper'
require 'contact_types_controller'

# Re-raise errors caught by the controller.
class ContactTypesController; def rescue_action(e) raise e end; end

class ContactTypesControllerTest < Test::Unit::TestCase
  fixtures :contact_types

  NEW_CONTACT_TYPE = {}  # e.g. {:name => 'Test ContactType', :description => 'Dummy'}
  REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

  def setup
    @controller = ContactTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # Retrieve fixtures via their name
    # @first = contact_types(:first)
    @first = ContactType.find_first
  end

end
