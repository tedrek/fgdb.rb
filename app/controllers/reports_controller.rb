class ReportsController < ApplicationController
  include XmlHelper
  MINIMUM_COMPAT_VERSION=1

  def check_compat
    if !params[:version] || params[:version].empty? || params[:version].to_i < MINIMUM_COMPAT_VERSION  
      render :xml => {:compat => false, :your_version => params[:version].to_i, :minimum_version => MINIMUM_COMPAT_VERSION, :message => "You need to update your version of printme\nTo do that, go to System, then Administration, then Update Manager. When update manager comes up, click Check and then click Install Updates.\nAfter that finishes, run printme again."}
    else
      render :xml => {:compat => true}
    end
  end

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

  def list_flagged
    @reports = Report.find_all_by_flag(true, :order => "id")
    if @reports.length == 0
      redirect_to(:action => "index", :error => "There are no flagged reports")
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

  def list_for_report
    if params[:id]==nil||params[:id]==[""]
      redirect_to(:action => "index", :error => "Please enter something") 
      return
    end
    if (params[:id][0].is_a?(String) && params[:id][0].length > 10)
      redirect_to(:action => "index", :error => "That report does not exist")
      return
    end
    @reports = Report.find_all_by_id(params[:id], :order => "id")
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
      @mistakes << "You should include something in the notes<br />(anything out of the ordinary, the key to enter BIOS, etc)<br />Click Edit to add to the notes"
    end
    if @report.contact
      if @report.contact.is_organization==true
        @mistakes << "The technician that you entered is an organization<br />(an organization cannot be a technician)<br />Click Edit to change the technician"
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

  def new_common_create_stuff(redirect_where_on_error, redirect_where_on_success)
    output = params[:report][:my_file].read
    if output == nil || output.empty?
      redirect_to(:action => redirect_where_on_error, :error => "The posted lshw output was empty!")
      return
    end
    if !load_xml(output)
      redirect_to(:action => redirect_where_on_error, :error => "Invalid XML!")
      return
    end
    # If we pass in the file descriptor to ActiveRecord, the file is already at the end so it will read an empty string
    params[:report].delete(:my_file)
    params[:report][:lshw_output] = output
    params[:report][:old_id]=params[:report][:system_id]
    params[:report][:system_id] = 0
    @report = Report.new(params[:report])
    @report.init
    if @report.get_serial != "(no serial number)"
      system = System.find_all_by_serial_number(@report.get_serial, :order => :id).first
      if system
        @report.system = system
      else
        @report.system = System.new
      end
    else
      @report.system = System.new
    end
    params[:report][:system_id] = @report.system.id
    if @report.save
      redirect_to(:action=>redirect_where_on_success, :id=>@report.id)
    else
      redirect_to(:action => redirect_where_on_error, :error => "Could not save the database record")
    end
  end

  def create
    new_common_create_stuff("new", "show") 
  end

  def xml_create
    params[:report]={:contact_id => params[:contact_id], :role_id => params[:role_id], :type_id => params[:type_id], :system_id => params[:system_id], :notes => params[:notes], :my_file => params[:my_file], :os => params[:os]}
    new_common_create_stuff("xml_index", "xml_show") 
  end

  def update
    @report = Report.find(params[:id])

    if @report.update_attributes(params[:report])
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "edit"
    end
  end

  def xml_system_show
    system = System.find_by_id(params[:id])
    if system
      render :xml => system
    else
      redirect_to(:action => "xml_index", :error => "That system does not exist!")
    end
  end

  def method_missing(symbol, *args)
    if (result = symbol.to_s.match(/(roles|types)_(new|edit|index|create|update|xml_index)/))
      @property_type=result[1]
      @action=result[2]
      eval "self." + "properties_" + @action
    else
      super
    end
  end
  
  def model
    @property_type.classify.constantize
  end

  def properties_xml_index
    @properties=model.find(:all, :order => "id")
    render :xml => @properties
  end

  def properties_index
    @properties = model.find(:all, :order => "id")
    render :action => "properties_" + @action
  end

  def properties_new
    @property = model.new
    render :action => "properties_" + @action
  end

  def properties_edit
    @property = model.find(params[:id])
    render :action  => "properties_" + @action
  end

  def properties_create
    @property = model.new(params[:property])

    if @property.save
      redirect_to(:action=>(@property_type + "_index"))
    else
      redirect_to(:action => (@property_type + "_new"), :error => "Could not save the database record")
    end
  end

  def properties_update
    @property = model.find(params[:id])

    if @property.update_attributes(params[:property])
      redirect_to(:action=>(@property_type + "_index"))
    else
      redirect_to(:action => (@property_type + "_new"), :error => "Could not save the database record")
    end
  end
end
