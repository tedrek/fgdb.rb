class SaleTxnsController < ApplicationController
  include AjaxScaffold::Controller
  require 'gizmo_tools'
  include DatalistFor
  GizmoEventsTag='sale_txns_gizmo_events'

  require 'logger'
  $LOG = Logger.new(File.dirname(__FILE__) + '/../../log/alog')
  
  after_filter :clear_flashes
  before_filter :update_params_filter

  def initialize
    @gizmo_context = GizmoContext.find(:first, :conditions => [ "name = ?", 'sale'])
    @gizmo_context_id = @gizmo_context.id
    @datalist_for_new_defaults = {
      GizmoEventsTag.to_sym  => {
        :gizmo_context_id => @gizmo_context_id
      }
    }
  end
  
  def update_params_filter
    update_params :default_scaffold_id => "sale_txn", :default_sort => nil, :default_sort_direction => "asc"
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
    @sort_sql = SaleTxn.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @sort_by = @sort_sql.nil? ? "#{SaleTxn.table_name}.#{SaleTxn.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @sale_txns = paginate(:sale_txns, :order => @sort_by, :per_page => default_per_page)
    
    render :action => "component", :layout => false
  end

  def new
    @sale_txn = SaleTxn.new
    @successful = true

    _set_totals_defaults(:new => true)
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
      @sale_txn = SaleTxn.new(params[:sale_txn])
      @successful = @sale_txn.save
      save_datalist(GizmoEventsTag, :sale_txn_id => @sale_txn.id, 
        :gizmo_context_id => @gizmo_context_id)

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
      @sale_txn = SaleTxn.find(params[:id])
      @successful = !@sale_txn.nil?
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
      @sale_txn = SaleTxn.find(params[:id])
      @successful = @sale_txn.update_attributes(params[:sale_txn])
      save_datalist(GizmoEventsTag, :sale_txn_id => @sale_txn.id,
        :gizmo_context_id => @gizmo_context_id)
    rescue
      flash[:error], @successful  = $!.to_s, false
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
      @successful = SaleTxn.find(params[:id]).destroy
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

  def receipt
    display_printable_invoice_receipt('receipt')
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
  def _set_totals_defaults(options = {})
    if (options[:new])
      @discount_schedule = DiscountSchedule.find(3)   #no discount
    else
      @discount_schedule = DiscountSchedule.find(@sale_txn.contact.discount_schedule_id)
    end
    @discount_schedule_description = @discount_schedule.description
    @gross_amount = @sale_txn.gross_amount || 0
    @discount_amount = 0
    @amount_due = @gross_amount - @discount_amount
  end

  # figure out total dollar amounts
  # based on quantities, gizmo types, attributes for each gizmo
  def calc_totals
    @discount_schedule = DiscountSchedule.find(params[:sale_txn][:discount_schedule_id])
    $LOG.debug "ENTERING SaleTxns::calc_totals #{Time.now}"
    #@formatted_params = nil #params.inspect.each {|par| "#{par}<br />"}
    $LOG.debug params.inspect
    options = { :context => @gizmo_context.name,
      :donated_discount_rate => @discount_schedule.donated_item_rate,
      :resale_discount_rate  => @discount_schedule.resale_item_rate
  }
    giztypes_list = 
      create_gizmo_types_detail_list(GizmoEventsTag, options)
    #@money_tendered = params[:donation][:money_tendered].to_f

    @gross_amount = giztypes_list.total('extended_gross_price')
    $LOG.debug "@gross_amount: #{@gross_amount.inspect}"
    @amount_due = 29 #giztypes_list.total('extended_price')
    $LOG.debug "@amount_due: #{@amount_due.inspect}"
    @discount_amount = 8 #giztypes_list.total('discount_applied')
    $LOG.debug "@discount_amount: #{@discount_amount.inspect}"
    @ask_user_setting = 'receipt'
  end

  # setup vars used by receipt, then render
  def display_printable_invoice_receipt(type=nil)
    @printurl = nil
    @print_window_options =
      "resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no,directories=no"
    type ||= 'receipt'
    @sale_txn = SaleTxn.find(params[:id])
    #$LOG.debug "@sale_txn: #{@sale_txn.inspect}"
    @sale_txn.discount_amount ||= 0.0
    @sale_txn.gross_amount ||= 0.0

    render :partial => 'sale_txn_detail_totals', 
      :layout => 'receipt_invoice', 
      :locals => { 
        :type => type, 
        :subtotal => @sale_txn.gross_amount,
        :discount => @sale_txn.discount_amount,
        :amount_due => @sale_txn.amount_due
      }
  end

  ###!!! 18nov gp  this method is deprecated
  # figure out then update fees and related totals for sale txn
  # based on quantities, gizmo types for each sold gizmo
  # render desired information
  def update_sale_txn_amounts
    $LOG.debug "ENTERING sale_txns_controller.rb::update_sale_txn_amounts #{Time.now}"
    #params.inspect.each {|par| $LOG.debug "#{par}, "}
    #@formatted_params = nil #params.inspect.each {|par| "#{par}<br />"}

    giztypes_list = create_gizmo_types_detail_list(GizmoEventsTag)

    # standard discount amount sums the standard extended
    # discount (based on discount schedule) over all gizmos in
    # this sale txn
    # it is displayed but cannot be changed
    #
    # (detail standard extended discount amounts are
    # automatically calculated whenever any change occurs to the
    # gizmo types or quantities in the sale txn.
    # each amount is written to corresponding discount applied amount)
    @standard_discount_amount =  giztypes_list.total('standard_extended_discount')

    # discount amount is the actual total discount given by
    # seller to customer, may vary from standard discount amount
    # it is the sum over all detail discount applied amounts
    @discount_amount = giztypes_list.total('discount_applied')

    # gross amount is the total amount due before any discounts
    # it reflects the extended price for every item in the txn
    # it is displayed but cannot be changed
    @gross_amount = giztypes_list.total('extended_price')

    # amount due is the actual amount charged customer
    # it reflects prices shown and the discount applied
    # (it is probably not settable by seller)
    @amount_due =  @gross_amount - @discount_applied

    # money tendered is amount given by customer, there may be
    # change due
    @money_tendered = params[:sale_txn][:money_tendered].to_f

    # change due is difference btw amount due and money tendered
    @change_due = @money_tendered - @amount_due

    $LOG.debug "Txn amounts: amount_due[#{@amount_due}], gross_amount[#{@gross_amount}, discount_amount[#{@discount_amount}]]"

    render :action => 'update_sale_txn_amounts.rjs'
  end
end
