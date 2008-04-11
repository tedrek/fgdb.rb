class SystemsController < ApplicationController
  def xml_show
begin
    @system = System.find(params[:id])
rescue
    @system = System.new
@system.save
end
    render :xml => @system 
  end

  def method_missing(symbol, *args)
    redirect_to :controller => "reports", :action => "index"
  end

  def xml_new
    @system = System.new
    @system.save
    render :xml => @system
  end
end
