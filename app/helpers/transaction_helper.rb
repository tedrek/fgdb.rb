module TransactionHelper
  include ApplicationHelper

  def base_controller
    raise RuntimeError.new('You best stop using /transactions')
  end

  def scaffold_columns(context)
    case context
    when 'sale'
      [
#       Column.new(Sale, :name => 'id', :eval => 'sale.id'),
       Column.new(Sale, :name => 'payment',
                  :eval => 'sale.payment', :sortable => false),
       Column.new(Sale, :name => 'buyer', :sortable => false, :eval => 'sale.buyer.display_name'),
       Column.new(Sale, :name => 'gizmos', :sortable => false),
       Column.new(Sale, :name => 'created_at', :eval => 'sale.created_at'),
      ]
    when 'donation'
      [
#       Column.new(Donation, :name => 'id'),
       Column.new(Donation, :name => 'payment',
                  :eval  => 'donation.payment', :sortable => false),
       Column.new(Donation, :name => 'donor', :sortable => false,
                  :eval => 'donation.donor.display_name'),
       Column.new(Donation, :name => 'gizmos', :sortable => false),
       Column.new(Donation, :name => 'created_at'),
      ]
    when 'disbursement'
      [
#       Column.new(Disbursement, :name => 'id'),
       Column.new(Disbursement, :name => 'disbursement_type', :sortable => false),
       Column.new(Disbursement, :name => 'recipient', :sortable => false,
                  :eval => 'disbursement.recipient.display_name'),
       Column.new(Disbursement, :name => 'gizmos', :sortable => false),
       Column.new(Disbursement, :name => 'disbursed_at'),
      ]
    when 'recycling'
      [
       Column.new(Recycling, :name => 'gizmos', :sortable => false),
       Column.new(Recycling, :name => 'recycled_at'),
      ]
    end
  end

  def totals_id(context)
    context + "_totals_div"
  end

end
