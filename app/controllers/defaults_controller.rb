class DefaultsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @default_pages, @defaults = paginate :defaults, :per_page => 10
  end

  def show
    @default = Default.find(params[:id])
  end

  def new
    @default = Default.new
  end

  def create
    @default = Default.new(params[:default])
    if @default.save
      flash[:notice] = 'Default was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @default = Default.find(params[:id])
  end

  def update
    @default = Default.find(params[:id])
    if @default.update_attributes(params[:default])
      flash[:notice] = 'Default was successfully updated.'
      redirect_to :action => 'show', :id => @default
    else
      render :action => 'edit'
    end
  end

  def destroy
    Default.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
