class DonationsController < ApplicationController
  include AjaxScaffold::Controller
  require 'gizmo_tools'
  include DatalistFor
  GizmoEventsTag='donations_gizmo_events' 

  require 'logger'
  $LOG = Logger.new(File.dirname(__FILE__) + '/../../log/alog')

  after_filter :clear_flashes
  before_filter :update_params_filter

  def initialize
    @gizmo_context_id = GizmoContext.find(:first, :conditions => [ "name = ?", 'donation']).id
    @datalist_for_new_defaults = {
      GizmoEventsTag.to_sym  => {
        :gizmo_context_id => @gizmo_context_id
      }
    }
  end
  
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

    @model_required_fee = 0
    @model_suggested_fee = 0
    @money_tendered = 0
    @expected_total_amount = @model_required_fee + @model_suggested_fee
    @overunder = @money_tendered - @expected_total_amount
    @gizmo_context_id = GizmoContext::Donation.id

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
      resolution = resolve_submit
      case resolution
      when 'invoice','receipt'
        _save(resolution)
      end
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return do_xhr_view(resolution, 'create.rjs') if request.xhr?
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

      @model_required_fee = 0
      @model_suggested_fee = 0
      @money_tendered = @donation.money_tendered
      @expected_total_amount = @model_required_fee + @model_suggested_fee
      @overunder = @money_tendered - @expected_total_amount
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
      resolution = resolve_submit
      case resolution
      when 'invoice','receipt'
        @donation.attributes = params[:donation]
        _save(resolution)
      end
    rescue
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end
    
    return do_xhr_view(resolution, 'update.rjs') if request.xhr?
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
  # render desired information
  def update_fee
    $LOG.debug "ENTERING DonationsController::update_fee #{Time.now}"
    $LOG.debug params.inspect
    #@formatted_params = nil #params.inspect.each {|par| "#{par}<br />"}

    calc_fees
    @options = { :scaffold_id => params[:scaffold_id]}
    render :action => 'update_fee.rjs'
  end

  def receipt
    display_printable_invoice_receipt('receipt')
  end

  def invoice
    display_printable_invoice_receipt('invoice')
  end

  def add_attrs_to_form
    @after_initial_page_load = true
    if params[:gizmo_type_id]
      render :update do |page|
        page.replace_html params[:div_id], :partial => 'gizmo_event_attr_form', :locals => { :params => params }
      end
    else
      render :text => ''
    end
  end


  private

  # record save common logic
  def _save(type)
    case type
    when 'invoice'
      @donation.txn_complete = false
      @donation.txn_completed_at = nil
    when 'receipt'
      @donation.txn_complete = true
      @donation.txn_completed_at = Time.now()
    end
    @successful = @donation.save
    save_datalist(GizmoEventsTag, :donation_id => @donation.id, 
      :gizmo_context_id => @gizmo_context_id)
  end

  # ajax scaffold post-update-or-create-button view handling
  def do_xhr_view(resolution, default_action)
    @printurl = nil
    @print_window_options =
      "resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no,directories=no"
    case resolution
    when 'ask'
      # unclear what to do; put up buttons for user choice
      @testflag = false
      return render(:action => 'show_buttons.rjs') if request.xhr?
    when 'receipt'
      # create a receipt to print
      @printurl = '/donations/receipt/' + @donation.id.to_s
      return render(:action => default_action) if request.xhr?
    when 'invoice'
      # create an invoice to print
      @printurl = '/donations/invoice/' + @donation.id.to_s
      return render(:action => default_action) if request.xhr?
    else
      # otherwise for chosen re-edits and all indecipherable input
      # just redisplay the edit screen
      return render(:action => default_action) if request.xhr?
    end
  end

  # compare amount tendered to expected per gizmo types, qtys
  def calc_fees
    @donation = Donation.find(params[:id])
    giztypes_list = create_gizmo_types_detail_list(GizmoEventsTag)
    @money_tendered = params[:donation][:money_tendered].to_f

    # these are calculated from model values
    @model_required_fee = giztypes_list.total('extended_required_fee')
    @donation.reported_required_fee = @model_required_fee
    $LOG.debug "@model_required_fee: #{@model_required_fee.inspect}"
    @model_suggested_fee = giztypes_list.total('extended_suggested_fee')
    @donation.reported_suggested_fee = @model_suggested_fee
    $LOG.debug "@model_suggested_fee: #{@model_suggested_fee.inspect}"
    @expected_total_amount = 
      @model_suggested_fee + @model_required_fee
    @overunder = @money_tendered - @expected_total_amount
  end

  # stash unit amounts, total counts by gizmo type
  #   for all gizmo events in txn
  def create_gizmo_types_detail_list(tag)
    gdl = GizmoTools::GizmoDetailList.new
    datalist_data(tag).each do |k,v|
      next if k.nil? or v.nil?
      type_id = v[:gizmo_type_id]
      count = v[:gizmo_count].to_i
      next if type_id.nil? or count.nil? or !count.kind_of?(Numeric)
      gdl.add(type_id, count)
    end
    $LOG.debug "gdl: #{gdl.inspect}"
    return gdl
  end

  # user has submitted form, what is the next step
  def resolve_submit
    resolve_arg = nil
    # calculate amount owed and set @overunder
    calc_fees
    # set default resolution per over/underpayment
    txn_res = 'receipt'   # base default value
    txn_res = 'ask' if @overunder < 0

    # adjust resolution if user has just given us input
    user_input = user_resolve_choice
    txn_res = user_input if user_input

    resolve_arg = case txn_res
    when 'invoice','receipt','ask'  then  txn_res
    when 'cancel'                   then  're-edit'
    else                                  're-edit'
    end
    return resolve_arg
  end

  # parse user choice regarding insufficient amount tendered
  def user_resolve_choice
    return nil unless params.has_key? :user_choice
    case params[:user_choice]
    when 'invoice','receipt','cancel'    then params[:user_choice]
    else                                      nil
    end
  end

  # setup vars used by invoice and receipt, then render
  def display_printable_invoice_receipt(type=nil)
    type ||= 'invoice'
    @donation = Donation.find(params[:id])
    @donation.reported_suggested_fee ||= 0.0
    @donation.money_tendered ||= 0.0
    @total_reported_fees = 
      @donation.reported_required_fee + @donation.reported_suggested_fee
    @required_fee_paid = 
      [@donation.reported_required_fee, @donation.money_tendered].min
    @required_fee_owed = 
      [0, @donation.reported_required_fee - @donation.money_tendered].max
    @cash_donation_paid = 
      [0, @donation.money_tendered - @donation.reported_required_fee].max
    @cash_donation_owed = 
      @donation.reported_suggested_fee - @cash_donation_paid

    render :partial => 'donation_detail_totals', 
      :layout => 'receipt_invoice', 
      :locals => { 
        :type => type, 
        :owed => @total_reported_fees - @donation.money_tendered,
        :cash_donation => @donation.reported_suggested_fee,
        :required_fee => @donation.reported_required_fee,
        :cash_donation_paid => @cash_donation_paid,
        :cash_donation_owed => @cash_donation_owed,
        :required_fee_paid => @required_fee_paid,
        :required_fee_owed => @required_fee_owed
      }
  end

end
