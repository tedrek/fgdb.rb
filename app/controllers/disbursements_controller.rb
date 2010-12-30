class DisbursementsController < TransactionController
  def default_condition
    "disbursed_at"
  end

  protected

  def get_required_privileges
    a = super
    a << {:except => ["destroy", "edit", "update"], :privileges => ['role_contact_manager', 'role_front_desk', 'role_store', 'role_volunteer_manager']}
    a << {:only => ["destroy", "edit", "update"], :privileges => ['role_bean_counter']}
    a
  end
end
