class CreateMeetingMinders < ActiveRecord::Migration
  def self.up
    create_table :meeting_minders do |t|
      t.integer :meeting_id
      t.integer :days_before
      t.string :recipient
      t.string :subject
      t.string :script
      t.text :body

      t.timestamps
    end

    add_foreign_key :meeting_minders, :meeting_id, :shifts, :id, :on_delete => :cascade
  end

  def self.down
    drop_table :meeting_minders
  end
end
