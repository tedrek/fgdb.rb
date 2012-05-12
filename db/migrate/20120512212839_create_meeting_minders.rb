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
  end

  def self.down
    drop_table :meeting_minders
  end
end
