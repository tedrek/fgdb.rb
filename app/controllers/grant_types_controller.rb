class GrantTypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @grant_type_pages, @grant_types = paginate :grant_types, :per_page => 10
  end

  def show
    @grant_type = GrantType.find(params[:id])
  end

  def new
    @grant_type = GrantType.new
  end

  def create
    @grant_type = GrantType.new(params[:grant_type])
    if @grant_type.save
      flash[:notice] = 'GrantType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @grant_type = GrantType.find(params[:id])
  end

  def update
    @grant_type = GrantType.find(params[:id])
    if @grant_type.update_attributes(params[:grant_type])
      flash[:notice] = 'GrantType was successfully updated.'
      redirect_to :action => 'show', :id => @grant_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    GrantType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
