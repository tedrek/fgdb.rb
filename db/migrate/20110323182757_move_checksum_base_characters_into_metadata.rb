class MoveChecksumBaseCharactersIntoMetadata < ActiveRecord::Migration
  def self.up
    Default["checksum_base"] =  (Default.is_pdx ? ((("a".."z").to_a + ("0".."9").to_a).select{|x| !["0", "o", "l", "1"].include?(x)}.sort_by{|x| rand(10)}.join("").upcase) : "0123456789ABCDEF")
  end

  def self.down
  end
end
