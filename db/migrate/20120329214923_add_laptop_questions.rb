class AddLaptopQuestions < ActiveRecord::Migration
  def self.up
    l = Type.find_by_name("laptop")
    l.id

    q1 = SpecSheetQuestion.new(:name => "Wireless", :question => "Is the system using a PCMCIA (External) or PCI Wireless Card?")
    q1.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => l.id)
    q1.save!

    q2 = SpecSheetQuestion.new(:name => "Has Wireless Switch", :question => "Is there a physical switch to toggle the Wireless on/off?")
    q2.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => l.id)
    q2.save!

    q3 = SpecSheetQuestion.new(:name => "Wireless Switch Location", :question => "Describe the relative location of the switch (e.g., Above keyboard, right side of chassis near optical drive, etc)")
    q3.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "has_wireless_switch", :operator => "=~", :expected_value => "^(y|Y)")
    q3.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => l.id)
    q3.save!

    q4 = SpecSheetQuestion.new(:name => "Has Wireless Key Combo", :question => "Is there a keyboard combination to toggle the Wireless on/off?")
    q4.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => l.id)
    q4.save!

    q5 = SpecSheetQuestion.new(:name => "Wireless Key Combination", :question => "Enter the key combination (e.g., Fn + F2)")
    q5.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "has_wireless_key_combo", :operator => "=~", :expected_value => "^(y|Y)")
    q5.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => l.id)
    q5.save!

    q6 = SpecSheetQuestion.new(:name => "Power Adapter Rating", :question => "What is the rating for the power adapter included with this system?\nPlease include voltage and amperage (e.g., 19.5V 3.42A)")
    q6.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => l.id)
    q6.save!
  end

  def self.down
  end
end
