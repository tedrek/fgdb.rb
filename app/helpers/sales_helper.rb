module SalesHelper
  include TransactionHelper

  def base_controller
    return '/sales'
  end

  def scaffold_columns
    [
      Column.new(Sale, :name => 'id'),
      Column.new(Sale, :name => 'payment',
                 :eval => 'sale.payment', :sortable => false),
      Column.new(Sale, :name => 'buyer', :sortable => false, :eval => 'sale.buyer'),
      Column.new(Sale, :name => 'gizmos', :sortable => false),
      Column.new(Sale, :name => 'created_at', :eval => 'sale.created_at'),
    ]
  end
end
