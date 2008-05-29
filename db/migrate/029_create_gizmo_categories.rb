class CreateGizmoCategories < ActiveRecord::Migration
  def self.up
    create_table :gizmo_categories do |t|
      t.column :description,             :string
    end
    add_column "gizmo_types", :gizmo_category_id, :bigint
    add_foreign_key "gizmo_types", [:gizmo_category_id], "gizmo_categories", [:id], :name => "gizmo_types_gizmo_categories_fk"

    system = GizmoCategory.create :description => "System"
    monitor = GizmoCategory.create :description => "Monitor"
    printer = GizmoCategory.create :description => "Printer"
    misc = GizmoCategory.create :description => "Misc"

    printers = ["Fax Machine", "Scanner", "Printer"]
    GizmoType.find(:all, 
                   :conditions => ["description in (?)", printers]).each do |gt|
      gt.gizmo_category_id = printer.id
      gt.save()
    end
    
    monitors = ["Monitor", "CRT", "LCD", "Old Data CRT"]
    GizmoType.find(:all, 
                   :conditions => ["description in (?)", monitors]).each do |gt|
      gt.gizmo_category_id = monitor.id
      gt.save()
    end

    systems = "System", "System w/builtin monitor", "Laptop", "1337 lappy"
    GizmoType.find(:all, 
                   :conditions => ["description in (?)", systems]).each do |gt|
      gt.gizmo_category_id = system.id
      gt.save()
    end

    GizmoType.find(:all, :conditions => "gizmo_category_id is null").each do |gt|
      gt.gizmo_category_id = misc.id
      gt.save()
    end
  end

  def self.down
    remove_foreign_key "gizmo_types", "gizmo_types_gizmo_categories_fk"
    remove_column "gizmo_types", :gizmo_category_id
    drop_table :gizmo_categories
  end
end
