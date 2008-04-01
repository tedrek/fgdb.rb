class PropertiesController < ApplicationController
  def set_property_type(type)
    @property_type=type
  end

  def method_missing(symbol, *args)
    redirect_to :controller => @property_type, :action => "index"
  end

  def model
    case @property_type
      when "role"
        Role
      when "type"
        Type
    end
  end

  def xml_index
    @properties=model.find(:all)
    render :xml => @properties
  end

  def index
    @properties = model.find(:all)
  end

  def new
    @property = model.new
  end

  def edit
    @property = model.find(params[:id])
  end

  def create
    @property = model.new(params[:role])

    if @property.save
      flash[:notice] = 'Role was successfully created.'
      redirect_to(:action=>"index")
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end

  def update
    @property = model.find(params[:id])

    if @property.update_attributes(params[:role])
      flash[:notice] = 'Role was successfully created.'
      redirect_to(:action=>"index")
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end
end
