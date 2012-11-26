class AddMorePrintmeQuestions < ActiveRecord::Migration
  def self.up
    ssq = SpecSheetQuestion.new
    ssq.name = 'Boot Device Menu Key'
    ssq.question = 'What is the BIOS key to select a boot device, if any?'
    ssq.save!

    ssq = SpecSheetQuestion.new
    ssq.name = 'Network Boot Key'
    ssq.question = 'What is the BIOS key to boot to the network, if any?'
    ssq.save!
  end

  def self.down
  end
end
