class DisbursementsController < TransactionController
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "disbursed_at"
  end

  protected

  def authorized_only
    requires_role('CONTACT_MANAGER', 'FRONT_DESK', 'STORE', 'VOLUNTEER_MANAGER')
  end

  def management_only
    requires_role(:BEAN_COUNTER)
  end
end
