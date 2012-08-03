class SystemPricingsController < ApplicationController
  layout :with_sidebar

  def index
    @system_pricings = SystemPricing.find(:all)
  end

  def show
    @system_pricing = SystemPricing.find(params[:id])
  end

  def new
    @system_pricing = SystemPricing.new
  end

  def edit
    @system_pricing = SystemPricing.find(params[:id])
  end

  def create
    @system_pricing = SystemPricing.new(params[:system_pricing])

    if @system_pricing.save
      flash[:notice] = 'SystemPricing was successfully created.'
      redirect_to({:action => "show", :id => @system_pricing.id})
    else
      render :action => "new"
    end
  end

  def update
    @system_pricing = SystemPricing.find(params[:id])

    if @system_pricing.update_attributes(params[:system_pricing])
      flash[:notice] = 'SystemPricing was successfully updated.'
      redirect_to({:action => "show", :id => @system_pricing.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @system_pricing = SystemPricing.find(params[:id])
    @system_pricing.destroy

    redirect_to({:action => "index"})
  end
end
