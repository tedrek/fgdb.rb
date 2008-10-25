class CreateGenerics < ActiveRecord::Migration
  def self.up
    create_table :generics do |t|
      t.string "value", :limit => 100, :null => false
      t.boolean "only_serial", :null => false, :default => true
      t.boolean "usable", :null => false, :default => true
      t.timestamps
    end
    add_index "generics", ["value"], :unique => true
    ['�����', '0123456789ABCDEF', '0123456789', '1234567890', 'MB-1234567890', 'SYS-1234567890', '00000000', 'xxxxxxxxxxx', 'EVAL', 'Serial number xxxxxx', 'XXXXXXXXXX', '$', 'xxxxxxxxxx', 'xxxxxxxxxxxx', 'xxxxxxxxxxxxxx', '0000000000', 'DELL', '0'].each{|x|
      Generic.new(:value => x).save!
    }
    ['System Name', 'Product Name', 'System Manufacturer', 'none', 'None', 'To Be Filled By O.E.M.', 'To Be Filled By O.E.M. by More String'].each{|x|
      Generic.new(:value => x, :only_serial => false).save!
    }
  end

  def self.down
    drop_table :generics
  end
end
