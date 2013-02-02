class PricingTypesController < ApplicationController
  layout :with_sidebar

  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['manage_pricing']}
    return a
  end
  public

  def index
    @pricing_types = PricingType.active
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
    orig_pricing_type = PricingType.find(params[:id])
    @pricing_type = orig_pricing_type.clone

    if @pricing_type.update_attributes(params[:pricing_type]) && @pricing_type.save
      orig_pricing_type.replaced_by_id = @pricing_type.id
      orig_pricing_type.ineffective_on = DateTime.now
      orig_pricing_type.save!
      flash[:notice] = 'PricingType was successfully updated.'
      redirect_to({:action => "edit", :id => @pricing_type.id})
    else
      render :action => "edit"
    end
  end

  def show_table
    @printme_pull_from = params[:id]
    pd = PricingData.find_all_by_printme_pull_from(@printme_pull_from)
    cols = pd.map{|x| x.lookup_type}.uniq.sort
    rows = pd.map{|x| x.printme_value}.uniq.sort
    data = {}
    pd.each{|x|
      data[[x.lookup_type, x.printme_value]] = x.lookup_value
    }
    @table = [[@printme_pull_from, *cols]]
    rows.each do |row|
      @table << [row, *cols.map{|col| data[[col, row]]}]
    end
  end

  def destroy
    @pricing_type = PricingType.find(params[:id])
    @pricing_type.ineffective_on = DateTime.now
    @pricing_type.save!

    redirect_to({:action => "index"})
  end
end
