class SkedsController < ApplicationController
  protected
  def get_required_privileges
    a = super
    a << {:privileges => ['admin_skedjul']}
    a
  end
  public

  layout :with_sidebar

  def index
    @skeds = Sked.find(:all)
  end

  def show
    @sked = Sked.find(params[:id])
  end

  def new
    @sked = Sked.new
  end

  def edit
    @sked = Sked.find(params[:id])
  end

  def create
    @sked = Sked.new(params[:sked])

    if @sked.save
      flash[:notice] = 'Sked was successfully created.'
      redirect_to({:action => "show", :id => @sked.id})
    else
      render :action => "new"
    end
  end

  def update
    params[:sked][:roster_ids] ||= []

    @sked = Sked.find(params[:id])

    if @sked.update_attributes(params[:sked])
      flash[:notice] = 'Sked was successfully updated.'
      redirect_to({:action => "show", :id => @sked.id})
    else
      render :action => "edit"
    end
  end

  def destroy
    @sked = Sked.find(params[:id])
    @sked.destroy

    redirect_to({:action => "index"})
  end
end
