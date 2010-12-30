class DonationsController < TransactionController
  def default_condition
    "created_at"
  end

  protected
end
