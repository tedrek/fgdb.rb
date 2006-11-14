class ReportsController < ApplicationController

  layout :report_layout_choice
  def report_layout_choice
    case action_name
    when /report$/ then 'reports_display.rhtml'
    else                'reports_form.rhtml'
    end
  end

  def volunteer_tasks
  end

  def volunteer_tasks_report
  end

  def income
  end

  def income_report
  end

end
