class CreateScsiCards < ActiveRecord::Migration
  def self.up
    create_table :scsi_cards do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :scsi_cards
  end
end
