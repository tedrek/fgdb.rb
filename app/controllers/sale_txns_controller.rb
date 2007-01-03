class SaleTxnsController < ApplicationController
  include AjaxScaffold::Controller
  include DatalistFor
  GizmoEventsTag='sale_txns_gizmo_events'

  after_filter :clear_flashes
  before_filter :update_params_filter
  layout :with_sidebar

  def initialize
    @gizmo_context = GizmoContext.sale
    @datalist_for_new_defaults = {
      :gizmo_context_id => @gizmo_context.id
    }
  end
  
  def update_params_filter
    update_params :default_scaffold_id => "sale_txn", :default_sort => nil, :default_sort_direction => "asc"
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
    @sort_sql = SaleTxn.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{SaleTxn.table_name}.#{SaleTxn.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @sale_txns = paginate(:sale_txns, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @sale_txn = SaleTxn.new
    @successful = true
    @initial_page_load = true
    _set_totals_defaults(:new => true)

    return render(:action => 'new.rjs')
  end
  
  def create
    begin
      @sale_txn = SaleTxn.new(params[:sale_txn])
      @successful = _save
    rescue
      flash[:error], @successful = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end
    
    return render(:action => 'create.rjs')
  end

  def edit
    begin
      @sale_txn = SaleTxn.find(params[:id])
      @successful = !@sale_txn.nil?
      @initial_page_load = true
      _set_totals_defaults
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'edit.rjs')
  end

  def update
    begin
      @sale_txn = SaleTxn.find(params[:id])
      @sale_txn.attributes = params[:sale_txn]
      @successful = _save
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'update.rjs')
  end

  def destroy
    begin
      @successful = SaleTxn.find(params[:id]).destroy
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
    if params[:sale_txn_id]
      @sale_txn = SaleTxn.find(params[:sale_txn_id])
    else
      @sale_txn = SaleTxn.new
    end
    render :update do |page|
      page.replace_html sale_txn_contact_searchbox_id(params), :partial => 'anonymous'
    end
  end

  def de_anonymize
    @options = params
    if params[:sale_txn_id]
      @sale_txn = SaleTxn.find(params[:sale_txn_id])
    else
      @sale_txn = SaleTxn.new
    end
    render :update do |page|
      page.replace_html sale_txn_contact_searchbox_id(params), :partial => 'contact_search'
    end
  end

  def update_discount_schedule
    if params[:sale_txn][:contact_id]
      default_discount_schedule = Contact.find(params[:sale_txn][:contact_id]).default_discount_schedule
    else
      default_discount_schedule = DiscountSchedule.no_discount
    end
    render :update do |page|
      page["sale_txn_discount_schedule_id"].value = default_discount_schedule.id
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
    @sale_txn = SaleTxn.new(params[:sale_txn])
    @sale_txn.gizmo_events = datalist_objects(GizmoEventsTag, @datalist_for_new_defaults).find_all {|gizmo|
      ! gizmo.mostly_empty?
    }
    render :update do |page|
      page.replace  header_totals_id(params), :partial => 'header_totals'
    end
  end

  #######
  private
  #######

  def _set_totals_defaults(options = {})
  end

  # common save logic
  def _save
    @sale_txn.gizmo_events = datalist_objects(GizmoEventsTag, @datalist_for_new_defaults).find_all {|gizmo|
      ! gizmo.mostly_empty?
    }
    @include_invoicing_choice = false
    if params.has_key? :user_choice
      # ignore underpayment at user request
      receipt_type = params[:user_choice]
    else
      # error regarding underpayment
      if @sale_txn.calculated_total > @sale_txn.money_tendered
        flash[:error] = "Amount tendered is too low"
        @include_invoicing_choice = true
        @successful = false
        return @successful
      elsif @sale_txn.calculated_total < @sale_txn.money_tendered
        flash[:error] = "Amount tendered is too much"
        @successful = false
        return @successful
      end
      receipt_type = 'receipt'
    end

    case receipt_type
    when 'invoice'
      @sale_txn.txn_complete = false
      @sale_txn.txn_completed_at = nil
      @sale_txn.payment_method = nil
    when 'receipt'
      @sale_txn.txn_complete = true
      @sale_txn.txn_completed_at = Time.now
      unless @sale_txn.payment_method
        flash[:error] = "Please choose a method of payment"
        @successful = false
        return @successful
      end
    end

    @sale_txn.reported_amount_due = @sale_txn.calculated_total
    @sale_txn.reported_discount_amount = @sale_txn.calculated_discount

    # :MC: lame!  validation should happen in the model.
    if (@sale_txn.postal_code and ! @sale_txn.postal_code.empty?) or
        (@sale_txn.contact_id)
      @successful = @sale_txn.save
      @printurl = "/sale_txns/%s/%d" % [receipt_type, @sale_txn.id]
    else
      flash[:error], @successful = "Please choose a buyer or enter an anonymous postal code.", false
    end
    return @successful
  end

  # setup vars used by receipt, then render
  def display_printable_invoice_receipt(type=nil)
    type ||= 'receipt'
    @sale_txn = SaleTxn.find(params[:id])

    render :partial => 'sale_txn_detail_totals', 
      :layout => 'receipt_invoice', 
      :locals => { 
        :type => type, 
        :subtotal => 0,
        :discount => 0,
        :amount_due => 0
      }
  end
end
