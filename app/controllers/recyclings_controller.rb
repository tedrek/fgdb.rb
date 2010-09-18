class RecyclingsController < TransactionController
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "recycled_at"
  end

  protected

  def authorized_only
    requires_privileges('role_recyclings', 'role_front_desk')
  end

  def management_only
    requires_privileges("role_bean_counter")
  end
end
