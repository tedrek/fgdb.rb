class DonationsController < TransactionController
  def civicrm_sync
    _civicrm_sync
  end

  protected

  def default_condition
    "created_at"
  end
end
