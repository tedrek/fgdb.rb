class AskBiosKeyDuringPrintme < ActiveRecord::Migration
  def self.up
    ssq = SpecSheetQuestion.new
    ssq.name = 'Boot Setup Key'
    ssq.question = 'What is the BIOS key to enter setup during boot?'
    ssq.save!
  end

  def self.down
  end
end
