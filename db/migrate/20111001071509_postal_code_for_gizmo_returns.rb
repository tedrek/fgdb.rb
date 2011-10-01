class PostalCodeForGizmoReturns < ActiveRecord::Migration
  def self.up
    add_column "gizmo_returns", "postal_code",       :string,   :limit => 25
  end

  def self.down
  end
end
