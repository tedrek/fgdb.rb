class PricingComponentsController < ApplicationController
  layout :with_sidebar

  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['manage_pricing']}
    return a
  end
  public

  def new
    @pricing_type = PricingType.find(params[:pricing_type_id])
    @pricing_component = PricingComponent.new
    @pricing_component.pricing_types << @pricing_type
  end

  def edit
    session[:pricing_refer] = request.env["HTTP_REFERER"]
    @pricing_component = PricingComponent.find(params[:id])
  end

  def create
    @pricing_type = PricingType.find(params[:pricing_type_id])
    @pricing_component = PricingComponent.new(params[:pricing_component])
    @pricing_component.pricing_types << @pricing_type

    if @pricing_component.save
      flash[:notice] = 'PricingComponent was successfully created.'
      redirect_to({:action => "edit", :controller => "pricing_types", :id => @pricing_type.id})
    else
      render :action => "new"
    end
  end

  def update
    @pricing_component = PricingComponent.find(params[:id])

    if @pricing_component.update_attributes(params[:pricing_component])
      flash[:notice] = 'PricingComponent was successfully updated.'
      redirect_to(session[:pricing_refer] || {:controller => "pricing_types"})
      session.delete(:pricing_refer)
    else
      render :action => "edit"
    end
  end

  def destroy
    @pricing_component = PricingComponent.find(params[:id])
    @pricing_component.destroy

    redirect_to({:action => "edit", :controller => "pricing_types", :id => @pricing_type.id})
  end
end
