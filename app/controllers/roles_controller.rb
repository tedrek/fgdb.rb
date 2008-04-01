class RolesController < ApplicationController
  def method_missing(symbol, *args)
    redirect_to :controller => "roles", :action => "index"
  end

  def xml_index
    @types=Type.find(:all)
    render :xml => @types
  end

  def index
    @roles = Role.find(:all)
  end

  def new
    @role = Role.new
  end

  def edit
    @role = Role.find(params[:id])
  end

  def create
    @role = role.new(params[:role])

    if @role.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to(:action=>"index")
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      flash[:notice] = 'Role was successfully created.'
      redirect_to(:action=>"index")
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end
end
