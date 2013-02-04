class PricingComponentsController < ApplicationController
  layout :with_sidebar

  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['manage_pricing']}
    return a
  end

  def make_a_table
    @pricing_values = @pricing_component.pricing_values
    header = ['ID', 'Name']
    if @pricing_component and @pricing_component.pull_from
    if @pricing_component.numerical?
      header << 'Minimum'
      header << 'Maximum'
    else
      header << 'Matcher'
      end
      end
    header << 'Value cents'
    @table = [header]

    for pricing_value in @pricing_values
      p = [pricing_value.id]
      p << pricing_value.name
      if @pricing_component and @pricing_component.pull_from
        if @pricing_component.numerical?
          p << pricing_value.minimum
          p << pricing_value.maximum
        else
          p << pricing_value.matcher
        end
      end
      p << pricing_value.value
      @table << p
    end
  end
  public

  def to_csv
    @pricing_component = PricingComponent.find(params[:id])
    make_a_table
    send_data @table.map{|x| x.shift; gencsv(x)}.join(""), :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=#{@pricing_component.name}.csv", :filename => "#{@pricing_component.name}.csv"
  end

  def new
    @pricing_expression = PricingExpression.find(params[:pricing_expression_id])
    @pricing_component = PricingComponent.new
    @pricing_component.pricing_expressions << @pricing_expression
  end

  def edit
    session[:pricing_refer] = request.env["HTTP_REFERER"]
    @pricing_component = PricingComponent.find(params[:id])
    make_a_table
  end

  def create
    @pricing_expression = PricingExpression.find(params[:pricing_expression_id])
    @pricing_component = PricingComponent.new(params[:pricing_component])
    @pricing_component.pricing_expressions << @pricing_expression

    if @pricing_component.save
      flash[:notice] = 'PricingComponent was successfully created.'
      redirect_to({:action => "edit", :controller => "pricing_types", :id => @pricing_expression.pricing_type.id})
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

    redirect_to({:action => "index", :controller => "pricing_types"})
  end
end
