class SalesController < TransactionController
  protected

  def default_condition
    "created_at"
  end
end
