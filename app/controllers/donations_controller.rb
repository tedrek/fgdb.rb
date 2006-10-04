class DonationsController < ApplicationController
  include AjaxScaffold::Controller
  include DatalistFor
  DonatedGizmosTag='donations_donated_gizmos' 

  require 'logger'
  $LOG = Logger.new(File.dirname(__FILE__) + '/../../log/alog')

  after_filter :clear_flashes
  before_filter :update_params_filter
  
  def update_params_filter
    update_params :default_scaffold_id => "donation", :default_sort => nil, :default_sort_direction => "asc"
  end
  def index
    redirect_to :action => 'list'
  end
  def return_to_main
    # If you have multiple scaffolds on the same view then you will want to change this to
    # to whatever controller/action shows all the views 
    # (ex: redirect_to :controller => 'AdminConsole', :action => 'index')
    redirect_to :action => 'list'
  end

  def list
  end
  
  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update
    @show_wrapper = false # don't show the outer wrapper elements if we are just updating an existing scaffold 
    if request.xhr?
      # If this is an AJAX request then we just want to delegate to the component to rerender itself
      component
    else
      # If this is from a client without javascript we want to update the session parameters and then delegate
      # back to whatever page is displaying the scaffold, which will then rerender all scaffolds with these update parameters
      return_to_main
    end
  end

  def component  
    @show_wrapper = true if @show_wrapper.nil?
    @sort_sql = Donation.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{Donation.table_name}.#{Donation.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @donations = paginate(:donations, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @donation = Donation.new
    @successful = true
    @required_fee = 0
    @suggested_fee = 1
    @money_tendered = 0
    @somefee = 999

    return render(:action => 'new.rjs') if request.xhr?

    # Javascript disabled fallback
    if @successful
      @options = { :action => "create" }
      render :partial => "new_edit", :layout => true
    else 
      return_to_main
    end
  end
  
  def create
    begin
      @donation = Donation.new(params[:donation])
      @successful = @donation.save
      save_datalist(DonatedGizmosTag, :donation_id => @donation.id)
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'create.rjs') if request.xhr?
    if @successful
      return_to_main
    else
      @options = { :scaffold_id => params[:scaffold_id], :action => "create" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def edit
    begin
      @donation = Donation.find(params[:id])
      @successful = !@donation.nil?
      @required_fee = 0
      @suggested_fee = 1
      @money_tendered = @donation.money_tendered
      @somefee = 999
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'edit.rjs') if request.xhr?

    if @successful
      @options = { :scaffold_id => params[:scaffold_id], :action => "update", :id => params[:id] }
      render :partial => 'new_edit', :layout => true
    else
      return_to_main
    end    
  end

  def update
    begin
      @donation = Donation.find(params[:id])
      @successful = @donation.update_attributes(params[:donation])
      save_datalist(DonatedGizmosTag)
    rescue
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end
    
    return render(:action => 'update.rjs') if request.xhr?

    if @successful
      return_to_main
    else
      @options = { :action => "update" }
      render :partial => 'new_edit', :layout => true
    end
  end

  def destroy
    begin
      @successful = Donation.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'destroy.rjs') if request.xhr?
    
    # Javascript disabled fallback
    return_to_main
  end
  
  def cancel
    @successful = true
    
    return render(:action => 'cancel.rjs') if request.xhr?
    
    return_to_main
  end

  # figure out then update fees and related totals for donation
  # based on quantities, gizmo types for each donated gizmo
  def update_fee
    $LOG.debug "ENTERING donations_controller.rb::update_fee #{Time.now}"
    params.inspect.each {|par| $LOG.debug par}

    #child_ids = donated_gizmo_subforms('donations_donated_gizmos')

    render :action => 'update_fee.rjs'

    # render_text('return from update_fee')
  end

#  def donated_gizmo_subforms(tag)
#    ids = []
#    ids << params[:datalist_update][tag.to_sym].values.first.keys
#    ids << params[:datalist_new][tag.to_sym].values.first.keys
#    return ids
#  end
end
