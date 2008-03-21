class ReportsController < ApplicationController
  # GET /reports
  # GET /reports.xml
  def index
    @error=nil
    if params[:error]
      @error=params[:error]
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def list_all
    @reports = Report.find(:all)

    respond_to do |format|
      format.html # list_all.html.erb
      format.xml  { render :xml => @reports }
    end
  end

  def list_for_contact
    if params[:id]!=nil&&params[:id]!=[""]
      @contact = Contact.find_by_id(params[:id])
      if @contact
        @reports = Report.find_all_by_contact_id(params[:id])
        if @reports.length > 0
          respond_to do |format|
            format.html # list_for_contact.html.erb
            format.xml  { render :xml => @reports }
          end
        else
          redirect_to (:action => "index", :error => "That contact has no reports")
        end        
      else
        redirect_to (:action => "index", :error => "That contact does not exist")
      end
    else
      redirect_to (:action => "index", :error => "Please enter something")
    end
  end

  def list_for_system
    if params[:id]!=[""]
      @system = System.find_by_id(params[:id])
      if @system
        @reports = Report.find_all_by_system_id(params[:id])
        if @reports.length > 0
          respond_to do |format|
            format.html # list_for_system.html.erb
            format.xml  { render :xml => @reports }
          end
        else
          redirect_to (:action => "index", :error => "That system has no reports")
        end
      else
        redirect_to (:action => "index", :error => "That system does not exist")
      end
    else 
      redirect_to (:action => "index", :error => "Please enter something")
    end
  end
  
  # GET /reports/1
  # GET /reports/1.xml
  def show
    @report = Report.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'fgss' } # show.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/new
  # GET /reports/new.xml
  def new
    @report = Report.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @report }
    end
  end

  # GET /reports/1/edit
  def edit
    @report = Report.find(params[:id])
  end

  # POST /reports
  # POST /reports.xml
  def create
    @report = Report.new(params[:report])

    respond_to do |format|
      if @report.save
        flash[:notice] = 'Report was successfully created.'
        format.html { redirect_to(:action=>"show", :id=>@report.id) }
        format.xml  { render :xml => @report, :status => :created, :location => @report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reports/1
  # PUT /reports/1.xml
  def update
    @report = Report.find(params[:id])

    respond_to do |format|
      if @report.update_attributes(params[:report])
        flash[:notice] = 'Report was successfully updated.'
        format.html { redirect_to(@report) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.xml
  def destroy
    @report = Report.find(params[:id])
    @report.destroy

    respond_to do |format|
      format.html { redirect_to(reports_url) }
      format.xml  { head :ok }
    end
  end
end
