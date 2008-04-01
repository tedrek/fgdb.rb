class TypesController < ApplicationController
  def index
    @types = Type.find(:all)
  end

  def show
    @type = Type.find(params[:id])
  end

  def new
    @type = Type.new
  end

  def edit
    @type = Type.find(params[:id])
  end

  def create
    @type = type.new(params[:report])

    if @type.save
      flash[:notice] = 'Type was successfully created.'
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end

  def update
    @type = Type.find(params[:id])

    if @type.update_attributes(params[:type])
      flash[:notice] = 'Type was successfully created.'
      redirect_to(:action=>"show", :id=>@report.id)
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end
end
