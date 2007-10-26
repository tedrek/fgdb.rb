require File.dirname(__FILE__) + '/../test_helper'
require 'discount_schedules_controller'

# Re-raise errors caught by the controller.
class DiscountSchedulesController; def rescue_action(e) raise e end; end

class DiscountSchedulesControllerTest < Test::Unit::TestCase
  fixtures :discount_schedules

        NEW_DISCOUNT_SCHEDULE = {:name => 'foo'}
        REDIRECT_TO_MAIN = {:action => 'list'} # put hash or string redirection that you normally expect

        def setup
                @controller = DiscountSchedulesController.new
                @request    = ActionController::TestRequest.new
                @response   = ActionController::TestResponse.new
                # Retrieve fixtures via their name
                # @first = discount_schedules(:first)
                @first = DiscountSchedule.find_first
        end

end
