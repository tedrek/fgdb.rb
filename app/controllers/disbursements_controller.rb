class DisbursementsController < TransactionController
  def default_condition
    "disbursed_at"
  end

  protected
end
