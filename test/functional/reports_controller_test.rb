require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  fixtures :contacts, :volunteer_tasks

  def test_hours_report_works
    assert_nothing_raised do
      get(:hours_report, {:contact_id => 3})
    end
  end
end
