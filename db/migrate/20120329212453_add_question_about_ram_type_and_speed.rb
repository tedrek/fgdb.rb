class AddQuestionAboutRamTypeAndSpeed < ActiveRecord::Migration
  def self.up
    bad_q = SpecSheetQuestion.find_by_name("Network Boot Key")
    bad_q.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => "-1")
    bad_q.save!

    boot_k = SpecSheetQuestion.find_by_name("Boot Device Menu Key")
    boot_k.question = "What is the BIOS key to select a boot device? (or 'N/A', if none applies)"
    boot_k.save!

    ram = SpecSheetQuestion.new(:name => "RAM Type", :question => "What is the type and speed of the RAM it uses?")
    for name in ["freekbox", "high_end", "grantbox", "regular"]
      ram.spec_sheet_question_conditions << SpecSheetQuestionCondition.new(:name => "type_id", :operator => "=", :expected_value => Type.find_by_name(name).id)
    end
    ram.save!
  end

  def self.down
  end
end
