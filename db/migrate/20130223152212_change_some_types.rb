class ChangeSomeTypes < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      # no more CRTs in sales
      GizmoType.effective_on(Date.today).find_by_name("monitor_crt").gizmo_contexts.delete(GizmoContext.sale)
      for i in ['xbmc', 'gaming']
        t = Type.new
        t.description = t.name = i
        t.created_by = t.updated_by = 1
        t.save!
      end
    end
  end

  def self.down
  end
end
