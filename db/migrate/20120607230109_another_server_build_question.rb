class AnotherServerBuildQuestion < ActiveRecord::Migration
  def self.up
    ssq = SpecSheetQuestion.new(:name => "DIMM Type", :question => "What type of DIMMs are the installed RAM sticks? (Registered, ECC, FB-DIMM, etc.)")
    ssq.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:expected_value => Type.find_by_name("server").id, :name => "type_id", :operator => "=")
    ssq.save
  end

  def self.down
  end
end
