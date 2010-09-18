class SalesController < TransactionController
#  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
#  before_filter :management_only, :only => ["destroy", "edit", "update"]

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
