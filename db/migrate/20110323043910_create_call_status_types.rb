class CreateCallStatusTypes < ActiveRecord::Migration
  def self.up
    create_table :call_status_types do |t|
      t.string :name

      t.timestamps
    end

    for i in ["left message", "spoke with person", "number not working", "no answer"]
      CallStatusType.new(:name => i).save!
    end

    add_column :assignments, :call_status_type_id, :integer
    add_foreign_key :assignments, :call_status_type_id, :call_status_types, :id, :on_destroy => :restrict
  end

  def self.down
    drop_table :call_status_types
    remove_column :assignments, :call_status_type_id
  end
end
