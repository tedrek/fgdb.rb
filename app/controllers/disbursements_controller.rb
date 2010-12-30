class DisbursementsController < TransactionController
  protected

  def default_condition
    "disbursed_at"
  end
end
