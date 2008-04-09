class ReportsController < ApplicationController
  include ReportsHelper

  def xml_index
    render :xml => {:error => params[:error]}
  end

  def index
    @error=params[:error]
  end

  def list_all
    @reports = Report.find(:all, :order => "id")
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
    if (params[:id][0].is_a?(String) && params[:id][0].length > 10) || !(@contact = Contact.find_by_id(params[:id]))
      redirect_to(:action => "index", :error => "That contact does not exist") 
      return
    end
    @reports = Report.find_all_by_contact_id(params[:id], :order => "id")
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
    if (params[:id][0].is_a?(String) && params[:id][0].length > 10) || !(@system = System.find_by_id(params[:id]))
      redirect_to(:action => "index", :error => "That system does not exist")
      return
    end
    @reports = Report.find_all_by_system_id(params[:id], :order => "id")
    if @reports.length == 0
      redirect_to(:action => "index", :error => "That system has no reports") 
      return
    end
  end

  def xml_list_for_system
    @reports = Report.find_all_by_system_id(params[:id], :order => "id")
    render :xml => @reports
  end
  
  def show
    @report = Report.find(params[:id])
    output=@report.lshw_output #only call db once
    if !(output) || output == ""
      redirect_to(:action => "index", :error => "There is no lshw output for that report!")
      return
    end
    if !load_xml(output)
      redirect_to(:action => "index", :error => "Invalid XML!")
      return
    end
    render :layout => 'fgss'
  end

  def xml_show
    @report = Report.find(params[:id])
    render :xml => @report
  end

  def new
    @report = Report.new
    @error=params[:error]
  end

  def edit
    @report = Report.find(params[:id])
  end

  def create
    if params[:report][:my_file] == nil || params[:report][:my_file] == ""
      redirect_to(:action => "new", :error => "There is no lshw output for that report!")
      return
    end
    output = params[:report][:my_file].read
    if !load_xml(output)
      redirect_to(:action => "new", :error => "Invalid XML!")
      return
    end
    # If we pass in the file descriptor to ActiveRecord, the file is already at the end so it will read an empty string
    params[:report].delete(:my_file)
    params[:report][:lshw_output] = output
    @report = Report.new(params[:report])
    if @report.system == nil
      @report.system = System.new
    end
    if @report.save
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end

  def xml_create
    if params[:my_file] == nil || params[:my_file] == ""
      redirect_to(:action => "xml_index", :error => "There is no lshw output for that report!")
      return
    end
    output = params[:my_file].read
    if !load_xml(output)
      redirect_to(:action => "xml_index", :error => "Invalid XML!")
      return
    end
    #stupid! Is there a better way to do that:
    report_params={:contact_id => params[:contact_id], :role_id => params[:role_id], :type_id => params[:type_id], :system_id => params[:system_id], :notes => params[:notes], :lshw_output => output, :os => params[:os]}
    @report = Report.new(report_params)
    if @report.system == nil
      @report.system = System.new
    end

    if @report.save
      params[:id]=@report.id
      xml_show
    else
      params[:error]="Could not save the database record"
      xml_index
    end
  end

  def update
    @report = Report.find(params[:id])

    if @report.update_attributes(params[:report])
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "edit"
    end
  end
end
