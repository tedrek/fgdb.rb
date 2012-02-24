class AddForeignKeysToConditionalQuestions < ActiveRecord::Migration
  def self.up
    add_foreign_key "spec_sheet_question_conditions", "spec_sheet_question_id", "spec_sheet_questions", "id", :on_delete => :restrict
    add_foreign_key "spec_sheet_values", "spec_sheet_id", "spec_sheets", "id", :on_delete => :cascade
    add_foreign_key "spec_sheet_values", "spec_sheet_question_id", "spec_sheet_questions", "id", :on_delete => :cascade
  end

  def self.down
  end
end
