class DisableWirelessLaptopsPrintmeQuestion < ActiveRecord::Migration
  def self.up
    DB.exec("UPDATE  spec_sheet_question_conditions SET expected_value = '-4' WHERE id IN (SELECT spec_sheet_question_conditions.id FROM spec_sheet_question_conditions JOIN spec_sheet_questions ON spec_sheet_questions.id = spec_sheet_question_id WHERE spec_sheet_questions.name LIKE 'Wireless');")
  end

  def self.down
  end
end
