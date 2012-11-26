class AddServerBuildQuestions < ActiveRecord::Migration
  def self.up
    q = SpecSheetQuestion.new(:name => "Case", :question => "Is it a tower or a rack-mount?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.save!

    q = SpecSheetQuestion.new(:name => "Height in Rack Units", :question => "How many rack units (u) is it?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "case", :operator => "=~", :expected_value => "^(r|R)")
    q.save!

    q = SpecSheetQuestion.new(:name => "Maximum Power Supplies", :question => "How many power supplies can it hold?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.save!

    q = SpecSheetQuestion.new(:name => "Current Power Supplies", :question => "How many power supplies are present?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "maximum_power_supplies", :operator => ">", :expected_value => "1")
    q.save!

    q = SpecSheetQuestion.new(:name => "Maximum Processors", :question => "How many processors can it hold?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.save!

    q = SpecSheetQuestion.new(:name => "Current Processors", :question =>  "How many processors are present?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "maximum_processors", :operator => ">", :expected_value => "1")
    q.save!

    q = SpecSheetQuestion.new(:name => "Maximum Hard Drives", :question => "How many hard drives can it hold?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.save!

    q = SpecSheetQuestion.new(:name => "Current Hard Drives", :question => "How many hard drives are present?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "maximum_hard_drives", :operator => ">", :expected_value => "1")
    q.save!

    q = SpecSheetQuestion.new(:name => "Hardware Raid Support", :question => "Does it support hardware raid?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "maximum_hard_drives", :operator => ">", :expected_value => "1")
    q.save!

    q = SpecSheetQuestion.new(:name => "Software Raid Support", :question => "Does it support software raid?")
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name('server').id.to_s)
    q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "maximum_hard_drives", :operator => ">", :expected_value => "1")
    q.save!
  end

  def self.down
    SpecSheetQuestionCondition.destroy_all
    SpecSheetQuestion.destroy_all
  end
end
