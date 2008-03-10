class RrSetsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rr_set_pages, @rr_sets = paginate :rr_sets, :per_page => 10
  end

  def show
    @rr_set = RrSet.find(params[:id])
  end

  def new
    @rr_set = RrSet.new
  end

  def create
    @rr_set = RrSet.new(params[:rr_set])
    if @rr_set.save
      flash[:notice] = 'RrSet was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @rr_set = RrSet.find(params[:id])
  end

  def update
    @rr_set = RrSet.find(params[:id])
    if @rr_set.update_attributes(params[:rr_set])
      flash[:notice] = 'RrSet was successfully updated.'
      redirect_to :action => 'show', :id => @rr_set
    else
      render :action => 'edit'
    end
  end

  def destroy
    RrSet.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
