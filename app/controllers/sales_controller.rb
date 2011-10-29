class SalesController < TransactionController
  protected

  private
  def new_trans_init_hook
    @transaction.discount_schedule_id = DiscountSchedule.find_by_name('no_discount').id
  end
  public

  def default_condition
    "created_at"
  end
end
