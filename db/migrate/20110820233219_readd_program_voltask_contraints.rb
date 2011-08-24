class ReaddProgramVoltaskContraints < ActiveRecord::Migration
  def self.up
    add_foreign_key "volunteer_task_types", ["program_id"], "programs", ["id"], :on_delete => :restrict
    add_foreign_key "volunteer_tasks", ["program_id"], "programs", ["id"], :on_delete => :restrict
  end

  def self.down
  end
end
