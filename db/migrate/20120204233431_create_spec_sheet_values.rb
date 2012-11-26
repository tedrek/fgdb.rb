class CreateSpecSheetValues < ActiveRecord::Migration
  def self.up
    create_table :spec_sheet_values do |t|
      t.integer :spec_sheet_id
      t.integer :spec_sheet_question_id
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :spec_sheet_values
  end
end
