class GizmoReturnsController < TransactionController
  protected
  def default_condition
    "created_at"
  end
end
