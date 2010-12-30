class DonationsController < TransactionController
  def default_condition
    "created_at"
  end

  protected

  def get_required_privileges
    a = super
    a << {:except => ["destroy", "edit", "update"], :privileges => ['role_front_desk']}
    a << {:only => ["destroy", "edit", "update"], :privileges => ['role_donation_admin', 'role_bean_counter']}
    a
  end
end
