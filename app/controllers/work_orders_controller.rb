class WorkOrdersController < ApplicationController
  layout :with_sidebar

  protected
  before_filter :ensure_metadata
  def ensure_metadata
    @@rt_metadata ||= _parse_metadata
  end
  def _parse_metadata
    h = {}
    cur = nil
    File.readlines(File.join(RAILS_ROOT, "config/rt_metadata.txt")).each do |line|
      line.strip!
      if line.match(/^== (.+) ==$/)
        cur = $1
        h[cur] = []
      else
        h[cur] << line.gsub(/^"(.+)"$/) do $1 end
      end
    end
    return h
  end
  public

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
