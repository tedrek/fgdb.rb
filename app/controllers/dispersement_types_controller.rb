class DispersementTypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @dispersement_type_pages, @dispersement_types = paginate :dispersement_types, :per_page => 10
  end

  def show
    @dispersement_type = DispersementType.find(params[:id])
  end

  def new
    @dispersement_type = DispersementType.new
  end

  def create
    @dispersement_type = DispersementType.new(params[:dispersement_type])
    if @dispersement_type.save
      flash[:notice] = 'DispersementType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @dispersement_type = DispersementType.find(params[:id])
  end

  def update
    @dispersement_type = DispersementType.find(params[:id])
    if @dispersement_type.update_attributes(params[:dispersement_type])
      flash[:notice] = 'DispersementType was successfully updated.'
      redirect_to :action => 'show', :id => @dispersement_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    DispersementType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
