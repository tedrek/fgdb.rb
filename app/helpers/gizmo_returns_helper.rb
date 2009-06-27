module GizmoReturnsHelper
  include TransactionHelper

  def base_controller
    return '/gizmo_returns'
  end

  def columns
    [
     Column.new(GizmoReturn, :name => 'id'),
     Column.new(GizmoReturn, :name => 'gizmos', :sortable => false),
     Column.new(GizmoReturn, :name => 'storecredit_difference'),
    ]
  end
end
