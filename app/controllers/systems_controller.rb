class SystemsController < ApplicationController
  def xml_show
    @system = System.find(params[:id])
    render :xml => @system 
  end

  def method_missing(symbol, *args)
    redirect_to :controller => "reports", :action => "index"
  end
  #I don't think we need  this
  #def xml_new
  #  @system = System.new
  #  @system.save
  #  render :xml => @system
  #end
end
