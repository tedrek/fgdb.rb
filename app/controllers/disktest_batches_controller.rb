class DisktestBatchesController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['data_security']}
    a
  end
  public

  layout :with_sidebar

  def search
    @error = params[:error]
    if !params[:conditions]
      params[:conditions] = {:created_at_enabled => "true"}
    end
    @conditions = Conditions.new
    @conditions.apply_conditions(params[:conditions])
    @disktest_batches = DisktestBatch.paginate(:page => params[:page], :conditions => @conditions.conditions(DisktestBatch), :order => "created_at ASC", :per_page => 50)
    render :action => "index"
  end

  def index
    search
  end

  def show
    @disktest_batch = DisktestBatch.find(params[:id])
  end

  def new
    @disktest_batch = DisktestBatch.new
  end

  def edit
    @disktest_batch = DisktestBatch.find(params[:id])
  end

  def create
    @disktest_batch = DisktestBatch.new(params[:disktest_batch])

    if @disktest_batch.save
      flash[:notice] = 'DisktestBatch was successfully created.'
      redirect_to({:action => "show", :id => @disktest_batch.id})
    else
      render :action => "new"
    end
  end

  def update
    @disktest_batch = DisktestBatch.find(params[:id])

    if @disktest_batch.update_attributes(params[:disktest_batch])
      flash[:notice] = 'DisktestBatch was successfully updated.'
      redirect_to({:action => "show", :id => @disktest_batch.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @disktest_batch = DisktestBatch.find(params[:id])
    @disktest_batch.destroy

    redirect_to({:action => "index"})
  end
end
