class GizmosController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @gizmo_pages, @gizmos = paginate :gizmos, :per_page => 10
  end

  def show
    @gizmo = Gizmo.find(params[:id])
  end

  def new
    @gizmo = Gizmo.new
  end

  def create
    @gizmo = Gizmo.new(params[:gizmo])
    if @gizmo.save
      flash[:notice] = 'Gizmo was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @gizmo = Gizmo.find(params[:id])
  end

  def update
    @gizmo = Gizmo.find(params[:id])
    if @gizmo.update_attributes(params[:gizmo])
      flash[:notice] = 'Gizmo was successfully updated.'
      redirect_to :action => 'show', :id => @gizmo
    else
      render :action => 'edit'
    end
  end

  def destroy
    Gizmo.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
