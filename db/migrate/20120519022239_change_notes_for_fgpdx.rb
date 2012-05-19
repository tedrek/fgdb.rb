class ChangeNotesForFgpdx < ActiveRecord::Migration
  def self.up
    if Default.is_pdx and (contract = Contract.find_by_name("city"))
      contract.notes = "FG-PDXs are earmarked for Portland residents.\nMake sure the contact is a Portland resident before completing this disbursement."
      contract.save!
    else
      puts "Skipping change to city contract for non-pdx database."
    end
  end

  def self.down
  end
end
