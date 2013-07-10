require File.dirname(__FILE__) + '/../test_helper'

class DisbursementTest < ActiveSupport::TestCase
  load_all_fixtures
  fixtures :disbursement_types

  WITH_CONTACT_INFO = {:contact_id => 1, :created_by => 1}

  def disbursed_system_event
    {
      :gizmo_type_id => GizmoType.find(:first, :conditions => ['description = ?', 'System']).id,
      :gizmo_count => 10,
      :gizmo_context => GizmoContext.disbursement,
      :as_is => false,
    }
  end

  def test_that_gizmo_events_occurred_when_disbursed
    disbursement = Disbursement.new(WITH_CONTACT_INFO)
    disbursement.disbursement_type_id = DisbursementType.find(:first).id
    disbursement.disbursed_at = Date.today - 1
    disbursement.gizmo_events = [GizmoEvent.new(disbursed_system_event)]
    assert disbursement.save, disbursement.errors.to_s
    disbursement = Disbursement.find(disbursement.id)
    event = disbursement.gizmo_events[0]
    assert_equal disbursement.disbursed_at, event.occurred_at
    assert_not_equal event.created_at, event.occurred_at
  end
end
