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
        d.comments "Disbursement automatically created from volunteer task with #{vt.duration} hours"
        d.contact_id = vt.contact_id
        d.disbursement_type_id = dt.id
        d.disbursed_at = vt.date_performed
        d.save!
      end

      vt.destroy
    end
  end

  def self.down
  end
end
