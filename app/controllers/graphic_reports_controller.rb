class GraphicReportsController < ApplicationController
  layout :with_sidebar

  def view
    generate_report_data
  end

  def index
    @report_types = report_types
    @breakdown_types = breakdown_types
  end

  private

  #########################
  # Time range type stuff #
  #########################

  # should return the total number of things that should be on the x
  # axis, minus one (this makes logical sense for simplicity)
  def number_between_them(end_date)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      (end_date - @start_date).to_i / 7
    when "Quarterly"
      (end_date - @start_date).to_i / 90 # MEEP. fix me.
    end
  end

  # returns true if this is a "good" date (ie, the beginning of the
  # week), or if it needs to be backed up further
  def is_last_thing?(date)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      date.strftime("%a") == "Sun"
    when "Quarterly"
      true # MEEP. fix me.
    end
  end

  # get the date object for number "breakdowns" after the start date
  def get_this_one(number)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      @start_date + (7*number)
    when "Quarterly"
      @start_date + (90*number) # MEEP. fix me.
    end
  end

  # convert a date object into the string that should be put on the x axis
  def x_axis_for(date)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      "Week of " + date.to_s
    when "Quarterly"
      string = date.strftime("%Y-Q")
      temp = date.strftime("%m").to_i
      hash = {:t1 => [1,2,3], :t2 => [4,5,6], :t3 => [7,8,9], :t4 => [10,11,12]}
      hash.each{|k,v|
        string += k.to_s.sub(/t/, "") if v.include?(temp)
      }
      string
    end
  end

  # get the last day in the range
  def second_timerange(first)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      first + 6
    when "Quarterly"
      first + 89 # MEEP. fix me, please.
    end
  end

  # list of breakdown types
  def breakdown_types
    ["Weekly", "Quarterly"]
  end

  #####################
  # Report type stuff #
  #####################

  # list of report types
  def report_types
    ["Income"]
  end

  # returns the title for that report type
  def get_title
    case params[:conditions][:report_type]
      when "Income"
      "Income report"
    end
  end

  # calls a method specific to that report that takes two arguements,
  # a start date and an end date, and returns the number that should
  # be plotted for that date range
  def get_thing_for_timerange(*args)
    case params[:conditions][:report_type]
      when "Income"
      get_income_for_timerange(*args)
    end
  end

  ######################
  # Random helper crap #
  ######################

  def generate_report_data
    list = []
    @start_date = Date.parse(params[:conditions][:start_date])
    @start_date = back_up_to_last_thing(@start_date)
    end_date = Date.parse(params[:conditions][:end_date])
    end_date = back_up_to_last_thing(end_date)
    (number_between_them(end_date) + 1).times{|x|
      list << get_this_one(x)
    }
    @title = get_title
    @data = {}
    @x_axis = []
    list.each{|x|
      @x_axis << x_axis_for(x)
    }
    @data[:income] = []
    list.each{|x|
      @data[:income] << get_thing_for_timerange(x.to_s, second_timerange(x).to_s)
    }
  end

  def back_up_to_last_thing(date)
    temp = date
    until is_last_thing?(temp)
      temp = temp - 1
    end
    return temp
  end

  def get_income_for_timerange(start_date, end_date)
    r = ReportsController.new
    r.income_report({"created_at_enabled" => "true", "created_at_date_type" => "arbitrary", "created_at_start_date" => start_date, "created_at_end_date" => end_date})[:grand_totals]["total"]["total"][:total] / 100.0
  end
end
