class RecyclingsController < TransactionController
  protected
  def default_condition
    "recycled_at"
  end

end
