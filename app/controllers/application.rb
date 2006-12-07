# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  layout "application"
  include DatebocksEngine

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
      next if type_id.nil? or type_id == ''
      count = fields[:gizmo_count]
      next if count.nil? or count == ''
      count = count.to_i
      next if !count.kind_of?(Numeric) or (count + 0 == 0)
      gizmo_options = list_options.merge(:field_hash => fields)
      #$LOG.debug "gizmo_options: #{gizmo_options.inspect}"
      gdl.add(row_id, count, gizmo_options)
    end
    $LOG.debug "gdl: #{gdl.inspect}"
    return gdl
  end

end
