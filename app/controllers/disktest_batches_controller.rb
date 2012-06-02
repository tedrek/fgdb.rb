class DisktestBatchesController < ApplicationController
  layout :with_sidebar

  def index
    @disktest_batches = DisktestBatch.find(:all)
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
