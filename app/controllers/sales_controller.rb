class SalesController < TransactionController
  def get_required_privileges
    a = super
    a << {:except => ["destroy", "edit", "update"], :privileges => ['role_store']}
    a << {:only => ["destroy", "edit", "update"], :privileges => ['role_store_admin', 'role_bean_counter']}
    a
  end

  def default_condition
    "created_at"
  end

  protected
end
