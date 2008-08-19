class GetRidOfViews < ActiveRecord::Migration
  def self.up
    drop_view :v_donations
    drop_view :v_donation_totals
  end

  def self.down
  end
end
