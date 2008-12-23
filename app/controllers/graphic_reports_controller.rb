class GraphicReportsController < ApplicationController
  layout :with_sidebar

  def view
    start_date = Date.parse("2008-11-30")
    number_of_weeks = 3
    list = []
    number_of_weeks.times{|x|
      list << start_date + (7*x)
    }
    @title = "Income report"
    @data = {}
    @x_axis = []
    list.each{|x|
      @x_axis << "Week of " + x.to_s
    }
    @data[:income] = []
    list.each{|x|
      @data[:income] << get_income_for_timerange(x.to_s, (x + 6).to_s) * 5
    }
  end

  def get_income_for_timerange(start_date, end_date)
    r = ReportsController.new
    r.income_report({"created_at_enabled" => "true", "created_at_date_type" => "arbitrary", "created_at_start_date" => start_date, "created_at_end_date" => end_date})[:grand_totals]["total"]["total"][:total] / 100.0
  end
end
