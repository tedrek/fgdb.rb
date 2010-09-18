class DisbursementsController < TransactionController
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "disbursed_at"
  end

  protected

  def authorized_only
    requires_privileges('role_contact_manager', 'role_front_desk', 'role_store', 'role_volunteer_manager')
  end

  def management_only
    requires_privileges("role_bean_counter")
  end
end
