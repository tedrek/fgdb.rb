class GraphicReportsController < ApplicationController
  layout :with_sidebar

  def view
    generate_report_data
  end

  def index
    @conditions = OpenStruct.new
  end

  private

  #########################
  # Time range type stuff #
  #########################

  def is_last_thing?(date)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      return date.strftime("%a") == "Sun"
    end
  end

  def get_this_one(number)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      @start_date + (7*number)
    end
  end

  def x_axis_for(date)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      "Week of " + date.to_s
    end
  end

  def second_timerange(first)
    case params[:conditions][:breakdown_type]
    when "Weekly"
      (first + 6).to_s
    end
  end

  #####################
  # Report type stuff #
  #####################

  def get_title
    case params[:conditions][:report_type]
      when "Income"
      "Income report"
    end
  end

  def get_thing_for_timerange(*args)
    case params[:conditions][:report_type]
      when "Income"
      return get_income_for_timerange(*args)
    end
  end

  ######################
  # Random helper crap #
  ######################

  def generate_report_info
    list = []
    @start_date = Date.parse(params[:conditions][:start_date])
    @start_date = back_up_to_last_thing(@start_date)
    params[:conditions][:number].to_i.times{|x|
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
      @data[:income] << get_thing_for_timerange(x.to_s, second_timerange(x))
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
