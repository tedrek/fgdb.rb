class GizmoReturnsController < TransactionController
  def default_condition
    "created_at"
  end

  protected
  def get_required_privileges
    a = super
    a << {:except => ["destroy", "edit", "update"], :privileges => ['role_store', 'role_tech_support']}
    a << {:only => ["destroy", "edit", "update"], :privileges => ['role_store_admin', 'role_bean_counter']}
    a
  end
end
