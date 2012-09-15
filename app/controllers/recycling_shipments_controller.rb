class RecyclingShipmentsController < ApplicationController
  def get_required_privileges
    a = super
    a << {:privileges => ['staff']}
    a
  end

  layout :with_sidebar

  def index
    @conditions = Conditions.new
    @conditions.unresolved_shipment_enabled = true
    @recycling_shipments = RecyclingShipment.paginate(:page => params[:page], :conditions => @conditions.conditions(RecyclingShipment), :order => "created_at ASC", :per_page => 50)
  end

  def search
    @conditions = Conditions.new
    @conditions.apply_conditions(params[:conditions])
    @recycling_shipments = RecyclingShipment.paginate(:page => params[:page], :conditions => @conditions.conditions(RecyclingShipment), :order => "created_at ASC", :per_page => 50)
    render :action => "index"
  end

  def show
    @recycling_shipment = RecyclingShipment.find(params[:id])
  end

  def new
    @recycling_shipment = RecyclingShipment.new
  end

  def edit
    @recycling_shipment = RecyclingShipment.find(params[:id])
  end

  def create
    @recycling_shipment = RecyclingShipment.new(params[:recycling_shipment])

    if @recycling_shipment.save
      flash[:notice] = 'RecyclingShipment was successfully created.'
      redirect_to({:action => "show", :id => @recycling_shipment.id})
    else
      render :action => "new"
    end
  end

  def update
    @recycling_shipment = RecyclingShipment.find(params[:id])

    if @recycling_shipment.update_attributes(params[:recycling_shipment])
      flash[:notice] = 'RecyclingShipment was successfully updated.'
      redirect_to({:action => "show", :id => @recycling_shipment.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @recycling_shipment = RecyclingShipment.find(params[:id])
    @recycling_shipment.destroy

    redirect_to({:action => "index"})
  end
end
