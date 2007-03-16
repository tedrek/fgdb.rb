class DonationsController < ApplicationController
  include AjaxScaffold::Controller
  include DatalistFor
  GizmoEventsTag='donations_gizmo_events' 
  PaymentsTag = 'donations_payments'

  after_filter :clear_flashes
  before_filter :update_params_filter

  layout :check_for_receipt
  def check_for_receipt
    case action_name
    when /receipt/ then "receipt_invoice.rhtml"
    else                "with_sidebar.rhtml"
    end
  end

  def initialize
    @gizmo_context = GizmoContext.donation
    @event_defaults = {
      :gizmo_context_id => @gizmo_context.id
    }
  end
  
  def update_params_filter
    update_params( :default_scaffold_id => "donation",
                   :default_sort => nil,
                   :default_sort_direction => "asc" )
    session[@scaffold_id][:conditions] ||= Conditions.new
    if params[:conditions]
      session[@scaffold_id][:conditions].apply_conditions(params[:conditions])
    end
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
    @conditions = current_conditions(params)
    @sort_by = @sort_sql.nil? ? "#{Donation.table_name}.#{Donation.primary_key} asc" : @sort_sql  + " " + current_sort_direction(params)
    @paginator, @donations = paginate( :donations, :order => @sort_by,
                                       :per_page => default_per_page,
                                       :conditions => @conditions.conditions(Donation) )
    
    render :action => "component", :layout => false
  end

  def new
    @donation = Donation.new
    @successful = true
    @initial_page_load = true

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
      flash[:error], @successful  = $!.to_s + "<hr />" + $!.backtrace.join("<br />").to_s, false #, false #
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
      @donation.postal_code = 97214
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
    events = datalist_objects( GizmoEventsTag, @event_defaults )
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
    @txn = @donation = Donation.find(params[:id])
    @context = 'donation'
  end

  def update_totals
    @donation = Donation.new(params[:donation])
    _apply_datalist_data(@donation)
    render :update do |page|
      page.replace header_totals_id(params), :partial => 'header_totals'
    end
  end

  #######
  private
  #######

  def _apply_datalist_data(donation)
    apply_datalist_to_collection(PaymentsTag, donation.payments)
    donation.payments.delete_if {|pmt| pmt.mostly_empty?}
    apply_datalist_to_collection(GizmoEventsTag, donation.gizmo_events, @event_defaults)
    donation.gizmo_events.delete_if {|gizmo| gizmo.mostly_empty?}
  end

  # common save logic
  def _save
    _apply_datalist_data(@donation)

    if @donation.invoiced?
      @donation.txn_complete = false
      @donation.txn_completed_at = nil
    else
      @donation.txn_complete = true
      @donation.txn_completed_at = Time.now
    end

    @donation.reported_required_fee = @donation.calculated_required_fee
    @donation.reported_suggested_fee = @donation.calculated_suggested_fee

    success = @donation.save
    if success
      @donation.payments.each {|payment| payment.save}
      @donation.gizmo_events.each {|gizmo| gizmo.save}
    end
    return success
  end

  def current_conditions(options)
    session[@scaffold_id][:conditions]
  end

end
