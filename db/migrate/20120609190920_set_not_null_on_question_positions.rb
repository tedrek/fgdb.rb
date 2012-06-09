class SetNotNullOnQuestionPositions < ActiveRecord::Migration
  def self.up
    change_column :spec_sheet_questions, :position, :integer, :null => false
  end

  def self.down
  end
end
