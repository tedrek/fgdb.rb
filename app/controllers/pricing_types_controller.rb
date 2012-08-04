class PricingTypesController < ApplicationController
  layout :with_sidebar

  def index
    @pricing_types = PricingType.find(:all)
  end

  def show
    @pricing_type = PricingType.find(params[:id])
  end

  def new
    @pricing_type = PricingType.new
  end

  def edit
    @pricing_type = PricingType.find(params[:id])
  end

  def create
    @pricing_type = PricingType.new(params[:pricing_type])

    if @pricing_type.save
      flash[:notice] = 'PricingType was successfully created.'
      redirect_to({:action => "edit", :id => @pricing_type.id})
    else
      render :action => "new"
    end
  end

  def update
    @pricing_type = PricingType.find(params[:id])

    if @pricing_type.update_attributes(params[:pricing_type])
      flash[:notice] = 'PricingType was successfully updated.'
      redirect_to({:action => "show", :id => @pricing_type.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @pricing_type = PricingType.find(params[:id])
    @pricing_type.destroy

    redirect_to({:action => "index"})
  end
end
