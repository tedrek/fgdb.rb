class GetRidOfWeirdForeignKeys < ActiveRecord::Migration
  def self.up
    for name in ["payments_sale_id_fk", "payments_donation_id_fkey"]
      begin
        remove_foreign_key("payments", name)
      rescue
      end
    end
  end

  def self.down
    # DUMB!
    begin
      add_foreign_key "payments", ["donation_id"], "donations", ["id"], :name => "payments_donation_id_fkey"
    rescue
    end
    begin
      add_foreign_key "payments", ["sale_id"], "sales", ["id"], :on_delete => :cascade, :name => "payments_sale_id_fk"
    rescue
    end
  end
end
