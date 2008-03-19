class GizmoEventsOccurredAt < ActiveRecord::Migration
  def self.up
    add_column 'gizmo_events', 'occurred_at', :datetime
    $stderr.puts '-- SET occurred_at = created_at'
    GizmoEvent.connection.execute("UPDATE gizmo_events
      SET occurred_at = created_at
      WHERE recycling_id IS NULL OR disbursement_id IS NULL")
    $stderr.puts '-- SET occurred_at = recyclings.recycled_at'
    GizmoEvent.connection.execute("UPDATE gizmo_events
      SET occurred_at = (
        SELECT recycled_at FROM recyclings
        WHERE recyclings.id = gizmo_events.recycling_id
      )
      WHERE recycling_id IS NOT NULL")
    $stderr.puts '-- SET occurred_at = disbursements.disbursed_at'
    GizmoEvent.connection.execute("UPDATE gizmo_events
      SET occurred_at = (
        SELECT disbursed_at FROM disbursements
        WHERE disbursements.id = gizmo_events.disbursement_id
      )
      WHERE disbursement_id IS NOT NULL")
  end

  def self.down
    remove_column 'gizmo_events', 'occurred_at'
  end
end
