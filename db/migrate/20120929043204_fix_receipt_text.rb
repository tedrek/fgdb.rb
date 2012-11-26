class FixReceiptText < ActiveRecord::Migration
  def self.up
    ReturnPolicy.all.each do |rp|
      rp.text = rp.text.sub("freegeek.org/thrift-store/warranty", "freegeek.org/system-warranty")
      rp.save!
    end
  end

  def self.down
  end
end
