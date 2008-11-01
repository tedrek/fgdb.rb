class NotNullOnFees < ActiveRecord::Migration
  def self.up
    [:suggested_fee_cents, :required_fee_cents].each{|x|
      GizmoType.connection.execute("ALTER TABLE gizmo_types ALTER #{x.to_s} SET NOT NULL")
    }
  end

  def self.down
  end
end
