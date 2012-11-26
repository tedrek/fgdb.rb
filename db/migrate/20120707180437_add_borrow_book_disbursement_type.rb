class AddBorrowBookDisbursementType < ActiveRecord::Migration
  def self.up
    if Default.is_pdx
      d = DisbursementType.new
      d.name = "borrowed"
      d.description = "Borrowed"
      d.save!
    end
  end

  def self.down
    if Default.is_pdx and d = DisbursementType.find_by_name("borrowed")
      d.destroy
    end
  end
end
