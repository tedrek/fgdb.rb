class DisbursementsController < TransactionController
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "disbursed_at"
  end

  protected

  def authorized_only
    requires_role('ROLE_CONTACT_MANAGER', 'ROLE_FRONT_DESK', 'ROLE_STORE', 'ROLE_VOLUNTEER_MANAGER')
  end

  def management_only
    requires_role(:ROLE_BEAN_COUNTER)
  end
end
