module RecyclingsHelper
  include TransactionHelper

  def base_controller
    return '/recyclings'
  end

  def scaffold_columns
    [
      Column.new(Recycling, :name => 'gizmos', :sortable => false),
      Column.new(Recycling, :name => 'recycled_at'),
    ]
  end
end
