class ReportsController < ApplicationController
  include ReportsHelper

  def index
    if params[:error]
      @error=params[:error]
    else
      @error=nil
    end
  end

  def list_all
    @reports = Report.find(:all)
    if @reports.length == 0
      redirect_to(:action => "index", :error => "There are no reports")
      return
    end
  end

  def list_for_contact
    if params[:id]==nil || params[:id]==[""]
      redirect_to(:action => "index", :error => "Please enter something")
      return
    end
    if params[:id][0].length > 10 || !(@contact = Contact.find_by_id(params[:id]))
      redirect_to(:action => "index", :error => "That contact does not exist") 
      return
    end
    @reports = Report.find_all_by_contact_id(params[:id])
    if @reports.length == 0
      redirect_to(:action => "index", :error => "That contact has no reports") 
      return
    end   
  end

  def list_for_system
    if params[:id]==nil||params[:id]==[""]
      redirect_to(:action => "index", :error => "Please enter something") 
      return
    end
    if params[:id][0].length > 10 || !(@system = System.find_by_id(params[:id]))
      redirect_to(:action => "index", :error => "That system does not exist")
      return
    end
    @reports = Report.find_all_by_system_id(params[:id])
    if @reports.length == 0
      redirect_to(:action => "index", :error => "That system has no reports") 
      return
    end
  end
  
  def show
    @report = Report.find(params[:id])
    if !(@report.lshw_output)
      redirect_to(:action => "index", :error => "There is no lshw output for that report!")
      return
    end
    render :layout => 'fgss'
  end

  def new
    @report = Report.new
  end

  def edit
    @report = Report.find(params[:id])
  end

  def create
    @report = Report.new(params[:report])
    if @report.system == nil
      @report.system = System.new
    end

    if @report.save
      flash[:notice] = 'Report was successfully created.'
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "new" 
    end
  end

  def update
    @report = Report.find(params[:id])

    if @report.update_attributes(params[:report])
      flash[:notice] = 'Report was successfully updated.'
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "edit"
    end
  end
end
