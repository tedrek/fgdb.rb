class ReportsController < ApplicationController
  include XmlHelper

  def dump
    response.headers['content-type'] = "application/xml; charset=utf-8"
    render :text => Report.find(params[:id]).lshw_output
  end

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
    if (params[:id][0].is_a?(String) && params[:id][0].length > 10) || !(@contact = Contact.find_by_id(params[:id])) && false # s/&& false// once it gets into fgdb.rb 
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
    @mistake_title = "Things you might have done wrong: "
    @mistakes = []
    if !@report.notes || @report.notes == ""
      @mistakes << "You should include something in the notes<br>(anything out of the ordinary, the key to enter BIOS, etc)<br>Click Edit to add to the notes"
    end
    if @report.contact
      if @report.contact.is_organization==true
        @mistakes << "The technician that you entered is an organization<br>(an organization cannot be a technician)<br>Click Edit to change the technician"
      end
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

def new_common_create_stuff
    sys_id=params[:report][:system_id]
    params[:report][:system_id] = 0
    @report = Report.new(params[:report])
    @report.init
    if @report.get_serial != "(no serial number)"
      @report.system = System.find_by_serial_number(@report.get_serial)
      if @report.system && !(@report.system.vendor == @report.get_vendor && @report.system.model == @report.get_model)
        @report.system = nil
      end
    end
    if @report.system == nil
      begin
      @report.system = System.find(sys_id) 
        rescue
        @report.system = nil
      end
      if @report.system == nil
        @report.system = System.new
      end
    end
    params[:report][:system_id] = @report.system.id
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

#    @report = Report.new(params[:report]) 

  
new_common_create_stuff

    
    if @report.save
      redirect_to(:action=>"show", :id=>@report.id)
    else
      redirect_to(:action => "new", :error => "Could not save the database record")
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
    params[:report]={:contact_id => params[:contact_id], :role_id => params[:role_id], :type_id => params[:type_id], :system_id => params[:system_id], :notes => params[:notes], :lshw_output => output, :os => params[:os]}

new_common_create_stuff

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
