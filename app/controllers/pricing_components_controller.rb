class PricingComponentsController < ApplicationController
  layout :with_sidebar

  def index
    @pricing_components = PricingComponent.find(:all)
  end

  def show
    @pricing_component = PricingComponent.find(params[:id])
  end

  def new
    @pricing_component = PricingComponent.new
  end

  def edit
    @pricing_component = PricingComponent.find(params[:id])
  end

  def create
    @pricing_component = PricingComponent.new(params[:pricing_component])

    if @pricing_component.save
      flash[:notice] = 'PricingComponent was successfully created.'
      redirect_to({:action => "show", :id => @pricing_component.id})
    else
      render :action => "new"
    end
  end

  def update
    @pricing_component = PricingComponent.find(params[:id])

    if @pricing_component.update_attributes(params[:pricing_component])
      flash[:notice] = 'PricingComponent was successfully updated.'
      redirect_to({:action => "show", :id => @pricing_component.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @pricing_component = PricingComponent.find(params[:id])
    @pricing_component.destroy

    redirect_to({:action => "index"})
  end
end
