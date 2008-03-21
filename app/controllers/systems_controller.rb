class SystemsController < ApplicationController
  # GET /systems
  # GET /systems.xml
  def index
    @systems = System.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @systems }
    end
  end

  # GET /systems/1
  # GET /systems/1.xml
  def show
    @system = System.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @system }
    end
  end

  # GET /systems/new
  # GET /systems/new.xml
  def new
    @system = System.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @system }
    end
  end

  # GET /systems/1/edit
  def edit
    @system = System.find(params[:id])
  end

  # POST /systems
  # POST /systems.xml
  def create
    @system = System.new(params[:system])

    respond_to do |format|
      if @system.save
        flash[:notice] = 'System was successfully created.'
        format.html { redirect_to(@system) }
        format.xml  { render :xml => @system, :status => :created, :location => @system }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /systems/1
  # PUT /systems/1.xml
  def update
    @system = System.find(params[:id])

    respond_to do |format|
      if @system.update_attributes(params[:system])
        flash[:notice] = 'System was successfully updated.'
        format.html { redirect_to(@system) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @system.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /systems/1
  # DELETE /systems/1.xml
  def destroy
    @system = System.find(params[:id])
    @system.destroy

    respond_to do |format|
      format.html { redirect_to(systems_url) }
      format.xml  { head :ok }
    end
  end
end
