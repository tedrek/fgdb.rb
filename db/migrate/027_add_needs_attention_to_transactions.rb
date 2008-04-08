class AddNeedsAttentionToTransactions < ActiveRecord::Migration

  TABLES = ["sales", "donations", "recyclings", "disbursements"]

  def self.up
    TABLES.each {|table|
      add_column table, :needs_attention, :boolean, :null => false, :default => false
    }
  end

  def self.down
    TABLES.each {|table|
      remove_column table, :needs_attention
    }
  end
end
