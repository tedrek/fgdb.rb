module GizmoReturnsHelper
  include TransactionHelper

  def base_controller
    return '/gizmo_returns'
  end

  def columns
    [
     Column.new(Sale, :name => 'id'),
     Column.new(Sale, :name => 'gizmos', :sortable => false),
     Column.new(Sale, :name => 'storecredit_difference'),
    ]
  end
end
