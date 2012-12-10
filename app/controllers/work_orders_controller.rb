class WorkOrdersController < ApplicationController
  layout :with_sidebar

  def index
    @work_orders = [OpenStruct.new]
  end

  def show
    @work_order = OpenStruct.new
  end

  def new
    @work_order = OpenStruct.new
  end

  def edit
    @work_order = OpenStruct.new
  end

  def create
    @work_order = OpenStruct.new(params[:work_order])

    if @work_order.save
      flash[:notice] = 'OpenStruct was successfully created.'
      redirect_to({:action => "show", :id => @work_order.id})
    else
      render :action => "new"
    end
  end

  def update
    @work_order = OpenStruct.new

    if @work_order.update_attributes(params[:work_order])
      flash[:notice] = 'OpenStruct was successfully updated.'
      redirect_to({:action => "show", :id => @work_order.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @work_order = OpenStruct.new
    @work_order.destroy

    redirect_to({:action => "index"})
  end
end
