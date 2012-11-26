module SalesHelper
  include TransactionHelper

  def base_controller
    return '/sales'
  end

  def columns
    [
     Column.new(Sale, :name => 'id'),
     Column.new(Sale, :name => 'payment',
                :eval => 'sale.payment', :sortable => false),
     Column.new(Sale, :name => 'discount', :sortable => false, :eval => 'sale.discount_name.description'),
     Column.new(Sale, :name => 'buyer', :sortable => false, :eval => 'sale.buyer'),
     Column.new(Sale, :name => 'gizmos', :sortable => false),
     Column.new(Sale, :name => 'occurred_at', :eval => 'sale.occurred_at'),
    ]
  end
end
