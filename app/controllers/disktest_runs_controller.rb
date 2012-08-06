class DisktestRunsController < ApplicationController
  layout :with_sidebar

  def index
    search
  end

  def show
    @disktest_run = DisktestRun.find(params[:id])
  end

  def history
    @serial = params[:serial]
    @disktest_runs = DisktestRun.find_all_by_serial_number(@serial)
  end

  def check_passed
    @serial = params[:id]
    result = !!DisktestRun.find_by_serial_number_and_result(@serial, 'PASSED')
    render :text => result.inspect
  end

  def search
    @error = params[:error]
    if !params[:conditions]
      params[:conditions] = {:created_at_enabled => "true"}
    end
    @conditions = Conditions.new
    @conditions.apply_conditions(params[:conditions])
    @disktest_runs = DisktestRun.paginate(:page => params[:page], :conditions => @conditions.conditions(DisktestRun), :order => "created_at ASC", :per_page => 50)
    render :action => "index"
  end
end
