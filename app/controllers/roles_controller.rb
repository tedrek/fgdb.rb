class RolesController < ApplicationController
  def index
    @types = Role.find(:all)
  end

  def show
    @type = Role.find(params[:id])
  end

  def new
    @type = Role.new
  end

  def edit
    @type = Role.find(params[:id])
  end

  def create
    @type = type.new(params[:report])

    if @type.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end

  def update
    @type = Role.find(params[:id])

    if @type.update_attributes(params[:type])
      flash[:notice] = 'Role was successfully created.'
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end
end
