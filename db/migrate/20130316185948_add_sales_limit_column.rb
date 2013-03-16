class AddSalesLimitColumn < ActiveRecord::Migration
  def self.up
    add_column :gizmo_types, :sales_limit, :integer
    if Default.is_pdx
      gt = GizmoType.find_by_name('barebones')
      gt.sales_limit = 5
      gt.save!
    end
  end

  def self.down
  end
end
