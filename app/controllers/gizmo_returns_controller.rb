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
            @transaction.gizmo_events << x.to_return_event(@transaction)
          end
        end
      else
        @extra_message = "Error: Could not load Disbursement ##{params[:disbursement_id]}, starting with empty transaction."
      end
    elsif params[:system_id]
      system = System.find_by_id(params[:system_id])
      if system
        if system.gone?
          gt = system.gizmo_events.select{|x| !x.gizmo_return_id}.first
          old_trans = gt.sale || gt.disbursement
          @extra_message = "This return will be automatically filled using information about System ##{system.id} from #{old_trans.class.to_s.titleize} ##{old_trans.id}.\nMake sure the information is correct below before saving."
          if ge = GizmoEvent.send("find_by_system_id_and_return_" + old_trans.class.table_name.singularize + "_id", system.id, old_trans.id)
            @extra_message += "\n\nWARNING: It looks like this system has already been returned in Gizmo Return ##{ge.gizmo_return_id}!"
          end
          def @transaction.contact_type
            @internal_ctype
          end
          def @transaction.set_internal_contact_type(val)
            @internal_ctype=val
          end
          @transaction.set_internal_contact_type(old_trans.class == Disbursement ? 'named' : old_trans.contact_type)
          @transaction.contact_id = old_trans.contact_id
          if old_trans.class == Sale
            @transaction.postal_code = old_trans.postal_code
          end
          @transaction.gizmo_events << gt.to_return_event(@transaction)
        else
          @extra_message = "Error: Could find any past transaction associated with System ##{system.id}, starting with empty transaction."
        end
      else
        @extra_message = "Error: Could not find any System with ##{params[:system_id]}, starting with empty transaction."
      end
#   elsif params[:sale_id]
# TODO, with store credit see comment in GizmoEvent.to_return_event
    end
  end

  protected
  def default_condition
    "created_at"
  end
end
