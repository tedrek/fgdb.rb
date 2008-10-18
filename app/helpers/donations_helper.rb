module DonationsHelper
  include TransactionHelper

  def base_controller
    return '/donations'
  end

  def columns
    [
     Column.new(Donation, :name => 'id'),
     Column.new(Donation, :name => 'payment',
                :eval  => 'donation.payment', :sortable => false),
     Column.new(Donation, :name => 'donor', :sortable => false,
                :eval => 'donation.donor'),
     Column.new(Donation, :name => 'gizmos', :sortable => false),
     Column.new(Donation, :name => 'created_at'),
    ]
  end
end
