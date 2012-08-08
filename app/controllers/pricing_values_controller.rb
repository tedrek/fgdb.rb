class PricingValuesController < ApplicationController
  layout :with_sidebar

  def new
    @pricing_value = PricingValue.new
  end

  def edit
    @pricing_value = PricingValue.find(params[:id])
  end

  def create
    @pricing_value = PricingValue.new(params[:pricing_value])

    if @pricing_value.save
      flash[:notice] = 'PricingValue was successfully created.'
      redirect_to({:action => "show", :id => @pricing_value.id})
    else
      render :action => "new"
    end
  end

  def update
    @pricing_value = PricingValue.find(params[:id])

    if @pricing_value.update_attributes(params[:pricing_value])
      flash[:notice] = 'PricingValue was successfully updated.'
      redirect_to({:action => "show", :id => @pricing_value.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @pricing_value = PricingValue.find(params[:id])
    @pricing_value.destroy

    redirect_to({:action => "index"})
  end
end
