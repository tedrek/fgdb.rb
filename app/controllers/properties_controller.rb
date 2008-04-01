class PropertiesController < ApplicationController
  before_filter :set_my_property_type

  def set_my_property_type
    @property_type=controller_name().gsub(/s$/, '')
  end

  def method_missing(symbol, *args)
    redirect_to :action => "index"
  end

  def model
    case @property_type
      when "role"
        Role
      when "type"
        Type
      else
        raise "I don't know about that kind of property"
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
    @property = model.new(params[:property])

    if @property.save
      redirect_to(:action=>"index")
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end

  def update
    @property = model.find(params[:id])

    if @property.update_attributes(params[:property])
      redirect_to(:action=>"index")
    else
      render :action => "new", :error => "Could not save the database record"
    end
  end
end
