# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  layout "application"
  include DatebocksEngine

  def receipt
    display_printable_invoice_receipt('receipt')
  end

  def invoice
    display_printable_invoice_receipt('invoice')
  end

  # recalculate controller-specific amounts, render results
  def update_totals
    calc_totals
    @options = { :scaffold_id => params[:scaffold_id]}
    render :update do |page|
      page.replace  header_totals_id(params), :partial => 'header_totals'
    end
  end

  private

  # stash unit amounts, total counts by gizmo type
  #   for all gizmo events in txn
  def create_gizmo_types_detail_list(tag, list_options={})
    list_options[:context] ||= @gizmo_context.name
    gdl = GizmoTools::GizmoDetailList.new(list_options)
    datalist_data(tag).each do |row_id,fields|
      next if row_id.nil? or fields.nil?
      #$LOG.debug "row_id,fields: #{row_id.inspect}, #{fields.inspect}"
      type_id = fields[:gizmo_type_id]
      count = fields[:gizmo_count].to_i
      next if type_id.nil? or count.nil? or !count.kind_of?(Numeric)
      gizmo_options = list_options.merge(:field_hash => fields)
      #$LOG.debug "gizmo_options: #{gizmo_options.inspect}"
      gdl.add(row_id, count, gizmo_options)
    end
    $LOG.debug "gdl: #{gdl.inspect}"
    return gdl
  end

  # user has submitted form, what is the next step
  def resolve_submit
    resolve_arg = nil
    # calculate amount owed and set @overunder
    calc_totals
    # set default resolution per over/underpayment
    txn_res = @ask_user_setting || 'receipt'   # base default value

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

  # ajax scaffold post-update-or-create-button view handling
  def do_xhr_view(resolution, default_action, controller, model_record)
    @printurl = nil
    @print_window_options =
      "resizable=yes,scrollbars=yes,status=no,toolbar=no,menubar=no,location=no,directories=no"

    case resolution
    when 'ask'
      # unclear what to do; put up buttons for user choice
      @testflag = false
      return render(:action => 'submit_choice_buttons.rjs') if request.xhr?
    when 'receipt'
      # create a receipt to print
      @printurl = "/#{controller}/receipt/" + model_record.id.to_s
      return render(:action => default_action) if request.xhr?
    when 'invoice'
      # create an invoice to print
      @printurl = "/#{controller}/invoice/" + model_record.id.to_s
      return render(:action => default_action) if request.xhr?
    else
      # otherwise for chosen re-edits and all indecipherable input
      # just redisplay the edit screen
      return render(:action => default_action) if request.xhr?
    end
  end
end
