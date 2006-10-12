class DonationsController < ApplicationController
  include AjaxScaffold::Controller
  include DatalistFor
  DonationLinesTag='donations_gizmo_events' 

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
    @overunder_fee = 0
    @demodisp = 999

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
      save_datalist(DonationLinesTag, :donation_id => @donation.id, :gizmo_action_id => GizmoAction.donation.id)
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
      @overunder_fee = 0
      @demodisp = 999
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
      save_datalist(DonationLinesTag, :donation_id => @donation.id, :gizmo_action_id => GizmoAction.donation.id)
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
    params.inspect.each {|par| $LOG.debug "#{par}, "}
    @formatted_params = nil #params.inspect.each {|par| "#{par}<br />"}

    #child_ids = gizmo_event_subforms('donations_gizmo_events')
    @demodisp = nil #"child_ids: " + child_ids.join(', ')
    @money_tendered = params[:donation][:money_tendered].to_f
    tag = 'donations_gizmo_events'
    gizmo_type_rollup = summarize_by_gizmo_type(tag)
    @required_fee =  calc_required_fee(gizmo_type_rollup).to_f
    @suggested_fee = calc_suggested_fee(gizmo_type_rollup).to_f
    @overunder_fee = @money_tendered - @required_fee
    $LOG.debug "Calculated fees: required_fee[#{@required_fee}], overunder_fee[#{@overunder_fee}]"

    render :action => 'update_fee.rjs'
  end

  def summarize_by_gizmo_type(tag)
    giztyp = {} 
    params[:datalist_new][tag.to_sym].values.first.each do |k,v| 
      $LOG.debug "k: #{k.inspect}; v: #{v.inspect}"
      next if k.nil? or v.nil?
      type_id = v[:gizmo_type_id]
      count = v[:gizmo_count].to_i
      $LOG.debug "type_id: #{type_id}; count: #{count}"
      next if type_id.nil? or count.nil? or !count.kind_of?(Numeric)
      h = { k => v }
      if giztyp.has_key?(type_id)
        giztyp[type_id.to_sym][:count] += (count >= 0 ? count : 0)
      else
        giztyp[type_id.to_sym] = {}
        giztyp[type_id.to_sym][:count]  = (count >= 0 ? count : 0)
      end
      $LOG.debug "giztyp: #{giztyp.inspect}"
      
#      if giztyp.has_key?(typ)
#        giztyp[typ][:required_fee] += 
#          (!h[k][:required_fee].nil? and h[k][:required_fee] >= 0)
#            ? h[k][:required_fee].to_f  : 0.0
#      else
#        giztyp[typ][:required_fee] = 
#          (!h[k][:required_fee].nil? and h[k][:required_fee] >= 0)
#            ? h[k][:required_fee].to_f  : 0.0
#      end
      #ids << k} unless params[:datalist_new].nil?
    end
    giztyp = { 
      1 => { :required_fee => 10.0, :quantity => 1, 
        :description => 'CRT'},
      2 => { :required_fee => 0.0, :quantity => 1, 
        :description => 'LCD'} 
      }
    return giztyp
  end

  def sum_hash_by_inner_key(myhash,inner_key)
    $LOG.debug "myhash: #{myhash.inspect}"
    fees = myhash.map {|id,rec| myhash[id][inner_key.to_sym]}
    $LOG.debug "Mapped fees: #{inner_key}[#{fees.inspect}]"
    sum = 0
    fees.each {|fee| sum += fee unless fee.nil?}
    return sum
  end

  def calc_required_fee(giztyp)
    sum_hash_by_inner_key(giztyp,'required_fee').to_f
  end

  def calc_suggested_fee(giztyp)
    sum_hash_by_inner_key(giztyp,'suggested_fee').to_f
  end

  def gizmo_event_subforms(tag)
    ids = []
    params[:datalist_update][tag.to_sym].values.first.each {|k,v| ids << k} unless params[:datalist_update].nil?
    params[:datalist_new][tag.to_sym].values.first.each    {|k,v| ids << k} unless params[:datalist_new].nil?
    return ids
  end
end
