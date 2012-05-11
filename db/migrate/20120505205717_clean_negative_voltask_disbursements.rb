class CleanNegativeVoltaskDisbursements < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.record_timestamps = false

    VolunteerTask.find(:all, :conditions => ['duration <= 0']).each do |vt|
      dt = nil
      if [0, -12, -24, -36, -48, -60].include?(vt.duration)
        if vt.duration == 0
          if vt.contact and vt.contact.is_organization
            dt = DisbursementType.find_by_name("hardware_grants")
          end
        else
          dt = DisbursementType.find_by_name("adoption")
        end
      end

      if dt
        d = Disbursement.new
        d.comments = "Disbursement automatically created from volunteer task with #{vt.duration} hours"
        d.contact_id = vt.contact_id
        if d.contact_id.nil?
          d.contact = Contact.find_or_create_by_organization('FGDB: Internal User For Historic Disbursements without Contacts')
          if d.contact.id.nil?
            d.contact.is_organization = false
            d.contact.first_name = 'FGDB Internal User'
            d.contact.last_name = 'For Historic Disbursements without Contacts'
            d.contact.postal_code = "97214"
            d.contact.save!
            d.contact_id = d.contact.id
          end
        end
        d.disbursement_type_id = dt.id
        d.disbursed_at = vt.date_performed
        d.gizmo_events << GizmoEvent.new(:gizmo_type => GizmoType.find_by_name('system'), :gizmo_count => 1, :gizmo_context => GizmoContext.disbursement)
        d.created_by = 1
        d.save!
      end

      vt.destroy
    end
  end

  def self.down
  end
end
