class RenameSalesTypes < ActiveRecord::Migration
  def self.up
    h = {"online" => "Online sales",
    "retail" => "Thrift store",
    "bulk" => "Bulk sales"}
    for k, v in h
      st = SaleType.find_by_name(k)
      st.description = v
      st.save!
    end
  end

  def self.down
  end
end
