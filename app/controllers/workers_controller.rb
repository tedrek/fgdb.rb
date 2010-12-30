class WorkersController < ApplicationController
  def get_required_privileges
    a = super
    a << {:privileges => ['role_skedjulnator', "role_bean_counter"]}
    a
  end

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @workers = Worker.paginate :order => 'name', :per_page => 20, :page => params[:page]
  end

  def show
    @worker = Worker.find(params[:id])
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(params[:worker])
    @worker.salaried = _parse_checkbox(params[:worker][:salaried])
    if @worker.save
      flash[:notice] = 'Worker was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @worker = Worker.find(params[:id])
    session["shift_return_to"] = "workers"
    session["shift_return_action"] = "edit"
    session["shift_return_id"] = @worker.id 
  end

  def _parse_checkbox(val)
    val = val.to_s
    if val == "1"
      return true
    elsif val == "0"
      return false
    else
      return nil
    end
  end

  def update
    @worker = Worker.find(params[:id])
    @worker.salaried = _parse_checkbox(params[:worker][:salaried])
    if !params[:worker][:job_ids]
      @worker.jobs.clear
    end
    if @worker.update_attributes(params[:worker])
      flash[:notice] = 'Worker was successfully updated.'
      redirect_to :action => 'show', :id => @worker
    else
      render :action => 'edit'
    end
  end

  def destroy
    Worker.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
