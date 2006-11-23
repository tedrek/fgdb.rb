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
    @gizmo_context = GizmoContext.find(:first, :conditions => [ "name = ?", 'donation'])
    @datalist_for_new_defaults = {
      GizmoEventsTag.to_sym  => {
        :gizmo_context_id => @gizmo_context.id
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
    @initial_page_load = true

      _set_totals_defaults

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
    
    return do_xhr_view(resolution, 'create.rjs', 'donations', @donation) if request.xhr?
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
      @initial_page_load = true

      _set_totals_defaults
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
      @donation.attributes = params[:donation]
      resolution = resolve_submit
      case resolution
      when 'invoice','receipt'
        _save(resolution)
      end
    rescue
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end
    
    return do_xhr_view(resolution, 'update.rjs', 'donations', @donation) if request.xhr?
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

  def add_attrs_to_form
    if params[:gizmo_type_id]
      render :update do |page|
        page.replace_html params[:div_id], :partial => 'gizmo_event_attr_form', :locals => { :params => params }
      end
    else
      render :text => ''
    end
  end

  def anonymize
    @options = params
    if params[:donation_id]
      @donation = Donation.find(params[:donation_id])
    else
      @donation = Donation.new
    end
    render :update do |page|
      page.replace_html donation_contact_searchbox_id(params), :partial => 'anonymous'
    end
  end

  def de_anonymize
    @options = params
    if params[:donation_id]
      @donation = Donation.find(params[:donation_id])
    else
      @donation = Donation.new
    end
    render :update do |page|
      page.replace_html donation_contact_searchbox_id(params), :partial => 'contact_search'
    end
  end


  private

  # set some default values used in view by new donation record
  def _set_totals_defaults
    @model_required_fee ||= 0
    @model_suggested_fee ||= 0
    @money_tendered = @donation.money_tendered || 0
    @expected_total_amount = @model_required_fee + @model_suggested_fee
    @overunder = @money_tendered - @expected_total_amount
  end

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
    @donation.reported_required_fee = @model_required_fee
    @donation.reported_suggested_fee = @model_suggested_fee
    if (@donation.postal_code and ! @donation.postal_code.empty?) or
        (@donation.contact_id and ! @donation.contact_id.nil?)
      @successful = @donation.save
      save_datalist(GizmoEventsTag, :donation_id => @donation.id, 
                    :gizmo_context_id => @gizmo_context.id)
    else
      # :MC: lame!  this should happen in the model.
      flash[:error], @successful = "Please choose a contact or enter the anonymous postal code.", false
    end
  end

  # figure out total dollar amounts
  # based on quantities, gizmo types, attributes for each gizmo
  def calc_totals
    $LOG.debug "ENTERING Donations::calc_totals #{Time.now}"
    #@formatted_params = nil #params.inspect.each {|par| "#{par}<br />"}
    $LOG.debug params.inspect
    options = { :context => @gizmo_context.name}
    giztypes_list = create_gizmo_types_detail_list(GizmoEventsTag, options)
    @money_tendered = params[:donation][:money_tendered].to_f

    # these are calculated from model values
    @model_required_fee = giztypes_list.total('extended_required_fee')
    $LOG.debug "@model_required_fee: #{@model_required_fee.inspect}"
    @model_suggested_fee = giztypes_list.total('extended_suggested_fee')
    $LOG.debug "@model_suggested_fee: #{@model_suggested_fee.inspect}"
    @expected_total_amount = 
      @model_suggested_fee + @model_required_fee
    @overunder = @money_tendered - @expected_total_amount
    @ask_user_setting = @model_required_fee > @money_tendered ?  'ask' : nil
  end

  # setup vars used by donation invoice and receipt, then render
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
