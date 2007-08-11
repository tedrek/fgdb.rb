class DisbursementTypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @disbursement_type_pages, @disbursement_types = paginate :disbursement_types, :per_page => 10
  end

  def show
    @disbursement_type = DisbursementType.find(params[:id])
  end

  def new
    @disbursement_type = DisbursementType.new
  end

  def create
    @disbursement_type = DisbursementType.new(params[:disbursement_type])
    if @disbursement_type.save
      flash[:notice] = 'DisbursementType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @disbursement_type = DisbursementType.find(params[:id])
  end

  def update
    @disbursement_type = DisbursementType.find(params[:id])
    if @disbursement_type.update_attributes(params[:disbursement_type])
      flash[:notice] = 'DisbursementType was successfully updated.'
      redirect_to :action => 'show', :id => @disbursement_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    DisbursementType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
