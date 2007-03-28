class TransactionController < ApplicationController
  include AjaxScaffold::Controller
  include DatalistFor

  after_filter :clear_flashes
  before_filter :update_params_filter

  layout :check_for_receipt
  def check_for_receipt
    case action_name
    when /receipt/ then "receipt_invoice.rhtml"
    else                "with_sidebar.rhtml"
    end
  end

  def update_params_filter
    update_params( :default_scaffold_id => transaction_type,
                   :default_sort => nil,
                   :default_sort_direction => "asc" )
    session[@scaffold_id][:conditions] ||= Conditions.new
    if params[:conditions]
      session[@scaffold_id][:conditions].apply_conditions(params[:conditions])
    end
    if params.has_key?(:transaction_type)
      set_transaction_type( params[:transaction_type] )
    elsif session[@scaffold_id].has_key?(:transaction_type)
      set_transaction_type( session[@scaffold_id][:transaction_type] )
    end
  end

  def index
    redirect_to :action => 'list'
  end

  def list
  end

  def donations
    set_transaction_type( 'donation' )
    redirect_to :action => 'list'
  end

  def sales
    set_transaction_type( 'sale' )
    redirect_to :action => 'list'
  end
  
  # All posts to change scaffold level variables like sort values or page changes go through this action
  def component_update
    @show_wrapper = false # don't show the outer wrapper elements if we are just updating an existing scaffold 
    component
  end

  def component  
    @show_wrapper = true if @show_wrapper.nil?
    @sort_sql = model.scaffold_columns_hash[current_sort(params)].sort_sql rescue nil
    @conditions = current_conditions(params)
    @sort_by = @sort_sql.nil? ? "#{model.table_name}.#{model.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @transactions = paginate( model.table_name.to_sym,
                                          :order => @sort_by,
                                          :per_page => default_per_page,
                                          :conditions => @conditions.conditions(model) )
    
    render :action => "component", :layout => false
  end

  def new
    @transaction = model.new
    @successful = true
    @initial_page_load = true

    return render(:action => 'new.rjs')
  end
  
  def create
    begin
      @transaction = model.new(params[transaction_type])
      @successful = _save
    rescue
      flash[:error], @successful = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false
    end

    render :action => 'create.rjs'
  end

  def edit
    begin
      @transaction = model.find(params[:id])
      @successful = !@transaction.nil?
      @initial_page_load = true
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'edit.rjs')
  end

  def update
    begin
      @transaction = model.find(params[:id])
      @transaction.attributes = params[transaction_type]
      @successful = _save
    rescue
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false #, false #
    end
    
    render :action => 'update.rjs'
  end

  def destroy
    begin
      @successful = model.find(params[:id]).destroy
    rescue
      flash[:error], @successful  = $!.to_s, false
    end
    
    return render(:action => 'destroy.rjs')
  end
  
  def cancel
    @successful = true
    
    return render(:action => 'cancel.rjs')
  end

  def automatic_datalist_row
    events = datalist_objects( gizmo_events_tag, gizmo_event_defaults )
    if( events.empty? or
          events.find {|ev| (! ev.valid?) or ev.mostly_empty? } ) # the datalist form is not filled in completely
      render :text => ''
    else
      # :MC: doctor the params for datalist_add_row
      # :TODO: rewrite datalist
      params[:model] = params["datalist_#{gizmo_events_tag}_model"]
      params[:options] = params["datalist_#{gizmo_events_tag}_options"]
      params[:datalist_id] = params["datalist_#{gizmo_events_tag}_id"]
      datalist_add_row
    end
  end

  def receipt
    @txn = @transaction = model.find(params[:id])
    @context = transaction_type
  end

  def update_totals
    @transaction = model.new(params[transaction_type])
    _apply_datalist_data(@transaction)
    render :action => 'update_totals.rjs' 
  end

  #######
  private
  #######

  def transaction_type
    @transaction_type || 'donation'
  end

  def set_transaction_type(type)
    @transaction_type = session[@scaffold_id][:transaction_type] = type
    @gizmo_context = GizmoContext.send(@transaction_type)
  end

  def totals_id(params)
    @transaction_type + '_totals_div'
  end

  def gizmo_event_defaults
    @event_defaults ||= {
      :gizmo_context_id => @gizmo_context.id
    }
  end

  def model
    case transaction_type
    when 'donation'
      Donation
    when 'sale'
      SaleTxn
    end
  end

  def gizmo_events_tag
    transaction_type + '_gizmo_events'
  end

  def payments_tag
    transaction_type + '_payments'
  end

  def _apply_datalist_data(transaction)
    apply_datalist_to_collection(payments_tag, transaction.payments)
    transaction.payments.delete_if {|pmt| pmt.mostly_empty?}
    apply_datalist_to_collection(gizmo_events_tag, transaction.gizmo_events, gizmo_event_defaults)
    transaction.gizmo_events.delete_if {|gizmo| gizmo.mostly_empty?}
  end

  # common save logic
  def _save
    _apply_datalist_data(@transaction)

    if @transaction.invoiced?
      @transaction.txn_complete = false
      @transaction.txn_completed_at = nil
    else
      @transaction.txn_complete = true
      @transaction.txn_completed_at = Time.now
    end

    @transaction.reported_required_fee = @transaction.calculated_required_fee
    @transaction.reported_suggested_fee = @transaction.calculated_suggested_fee

    success = @transaction.save
    if success
      @transaction.payments.each {|payment| payment.save}
      @transaction.gizmo_events.each {|gizmo| gizmo.save}
    end
    return success
  end

end
