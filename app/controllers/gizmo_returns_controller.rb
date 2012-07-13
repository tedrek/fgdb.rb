class GizmoReturnsController < TransactionController
  private
  def new_trans_init_hook
    if params[:disbursement_id]
      disbursement = Disbursement.find_by_id(params[:disbursement_id])
      if disbursement
        @extra_message = "This return will be automatically filled using Disbursement ##{disbursement.id}.\nMake sure the information is correct below before saving."
        def @transaction.contact_type
          'named'
        end
        @transaction.contact_id = disbursement.contact_id
        disbursement.gizmo_events.each do |x|
          x.gizmo_count.times do
            @transaction.gizmo_events << GizmoEvent.new(:gizmo_type_id => x.gizmo_type_id, :return_disbursement_id => disbursement.id, :description => x.description, :system_id => x.system_id, :unit_price_cents => 0, :gizmo_return => @transaction, :gizmo_type => x.gizmo_type, :gizmo_context => GizmoContext.gizmo_return, :gizmo_count => 1)
          end
        end
      end
    end
  end

  protected
  def default_condition
    "created_at"
  end
end
