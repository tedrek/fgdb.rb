class RemoveFeeDiscountFromDonationContext < ActiveRecord::Migration
  def self.up
    Contact.connection.execute("
      DELETE FROM gizmo_contexts_gizmo_types gcgt
      WHERE gizmo_context_id=(SELECT gc.id
                              FROM gizmo_contexts gc
                              WHERE gc.name='donation')
            AND gizmo_type_id=(SELECT gt.id
                               FROM gizmo_types gt
                               WHERE gt.name='fee_discount')
      ")
  end

  def self.down
    gc_id = Contact.connection.execute("
      SELECT gc.id
      FROM gizmo_contexts gc
      WHERE gc.name='donation'
      ")[0][0]
    gt_id = Contact.connection.execute("
      SELECT gt.id
      FROM gizmo_types gt
      WHERE gt.name='fee_discount'
      ")[0][0]

    Contact.connection.execute("
      INSERT INTO gizmo_contexts_gizmo_types (gizmo_context_id, gizmo_type_id)
      VALUES (#{gc_id}, #{gt_id})
      ")
  end
end
