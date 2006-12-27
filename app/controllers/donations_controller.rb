class DonationsController < ApplicationController
  include AjaxScaffold::Controller
  include DatalistFor
  GizmoEventsTag='donations_gizmo_events' 

  after_filter :clear_flashes
  before_filter :update_params_filter

  def initialize
    @gizmo_context = GizmoContext.donation
    @datalist_for_new_defaults = {
      :gizmo_context_id => @gizmo_context.id
    }
  end
  
  def update_params_filter
    update_params :default_scaffold_id => "donation", :default_sort => nil, :default_sort_direction => "asc"
  end

  def index
    redirect_to :action => 'list'
  end

  def list
  end
  
  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update
    @show_wrapper = false # don't show the outer wrapper elements if we are just updating an existing scaffold 
    component
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

    return render(:action => 'new.rjs')
  end
  
  def create
    begin
      @donation = Donation.new(params[:donation])
      @successful = _save
    rescue
      flash[:error], @successful = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end

    render :action => 'create.rjs'
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
    
    return render(:action => 'edit.rjs')
  end

  def update
    begin
      @donation = Donation.find(params[:id])
      @donation.attributes = params[:donation]
      @successful = _save
    rescue
      flash[:error], @successful  = $!.to_s, false # + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end
    
    render :action => 'update.rjs'
  end

  def destroy
    begin
      @successful = Donation.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'destroy.rjs')
  end
  
  def cancel
    @successful = true
    
    return render(:action => 'cancel.rjs')
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

  def automatic_datalist_row
    events = datalist_objects( GizmoEventsTag, @datalist_for_new_defaults )
    if( events.empty? or
          events.find {|ev| (! ev.valid?) or ev.mostly_empty? } ) # the datalist form is not filled in completely
      render :text => ''
    else
      # :MC: doctor the params for datalist_add_row
      params[:model] = params["datalist_#{GizmoEventsTag}_model"]
      params[:options] = params["datalist_#{GizmoEventsTag}_options"]
      params[:datalist_id] = params["datalist_#{GizmoEventsTag}_id"]
      datalist_add_row
    end
  end

  def receipt
    display_printable_invoice_receipt('receipt')
  end

  def invoice
    display_printable_invoice_receipt('invoice')
  end

  def update_totals
    @donation = Donation.new(params[:donation])
    @donation.gizmo_events = datalist_objects(GizmoEventsTag, @datalist_for_new_defaults).find_all {|gizmo|
      ! gizmo.mostly_empty?
    }
    render :update do |page|
      page.replace  header_totals_id(params), :partial => 'header_totals'
    end
  end

  #######
  private
  #######

  # set some default values used in view by new donation record
  def _set_totals_defaults
    @model_required_fee ||= 0
    @model_suggested_fee ||= 0
    @money_tendered = @donation.money_tendered || 0
    @expected_total_amount = @model_required_fee + @model_suggested_fee
    @overunder = @money_tendered - @expected_total_amount
  end

  # common save logic
  def _save
    @donation.gizmo_events = datalist_objects(GizmoEventsTag, @datalist_for_new_defaults).find_all {|gizmo|
      ! gizmo.mostly_empty?
    }
    @include_invoicing_choice = false
    if params.has_key? :user_choice
      # ignore underpayment at user request
      receipt_type = params[:user_choice]
    else
      # error regarding underpayment
      unless @donation.required_paid?
        flash[:error] = "Amount tendered is too low"
        @include_invoicing_choice = true
        @successful = false
        return @successful
      end
      receipt_type = 'receipt'
    end

    case receipt_type
    when 'invoice'
      @donation.txn_complete = false
      @donation.txn_completed_at = nil
      @donation.payment_method = PaymentMethod.invoice
    when 'receipt'
      @donation.txn_complete = true
      @donation.txn_completed_at = Time.now
    end
    @donation.reported_required_fee = @donation.calculated_required_fee
    @donation.reported_suggested_fee = @donation.calculated_suggested_fee
    # :MC: lame!  validation should happen in the model.
    if (@donation.postal_code and ! @donation.postal_code.empty?) or
        (@donation.contact_id)
      @successful = @donation.save
      @printurl = "/donations/%s/%d" % [receipt_type, @donation.id]
    else
      flash[:error], @successful = "Please choose a donor or enter an anonymous postal code.", false
    end
    return @successful
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
