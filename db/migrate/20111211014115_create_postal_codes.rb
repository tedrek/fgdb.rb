class CreatePostalCodes < ActiveRecord::Migration
  def self.up
    create_table :postal_codes do |t|
      t.string :postal_code, :unique => true
      t.string :city

      t.timestamps
    end
    "97086 97201 97202 97203 97204 97205 97206 97207 97208 97209 97210 97211 97212 97213 97214 97215 97216 97217 97218 97219 97220 97221 97222 97223 97224 97225 97227 97228 97229 97230 97231 97232 97233 97236 97238 97239 97240 97242 97256 97258 97266 97267 97268 97269 97280 97281 97282 97283 97286 97290 97291 97292 97293 97294 97296 97298 97299".split(" ").each {|x|
      PostalCode.new(:city => "Portland", :postal_code => x).save!
    }
    ["00000", "", nil].each{|x|
      PostalCode.new(:city => "No Data", :postal_code => x).save!
    }
  end

  def self.down
    drop_table :postal_codes
  end
end
