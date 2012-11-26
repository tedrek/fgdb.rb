class ChangeServerbuildQuestions < ActiveRecord::Migration
  def self.up
    ssq = SpecSheetQuestion.find_by_name("Maximum Processors")
    ssq.spec_sheet_question_conditions.each do |x|
      if x.name == "type_id"
        x.expected_value = -1
        x.save
      end
    end
    ssq = SpecSheetQuestion.find_by_name("Current Processors")
    ssq.spec_sheet_question_conditions.each do |x|
      x.destroy if x.name == "maximum_processors"
    end
    ssq = SpecSheetQuestion.new(:name => "Cores per Processor", :question => "How many cores does each processors have?")
    ssq.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name("server").id)
    ssq.save!
  end

  def self.down
  end
end
