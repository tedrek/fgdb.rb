class DonationsController < TransactionController
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "created_at"
  end

  protected

  def authorized_only
    requires_role(:FRONT_DESK)
  end

  def management_only
    requires_role(:DONATION_ADMIN, :BEAN_COUNTER)
  end
end
