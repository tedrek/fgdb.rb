class MoveChecksumBaseCharactersIntoMetadata < ActiveRecord::Migration
  def self.up
    Default["checksum_base"] = "0123456789ABCDEF"
  end

  def self.down
  end
end
