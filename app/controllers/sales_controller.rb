class SalesController < TransactionController
  private
  def new_trans_init_hook
    @transaction.discount_schedule_id = DiscountSchedule.find_by_name('no_discount').id
  end
  public

  def display
    @txn = @transaction = model.find(params[:id])
    @context = @transaction_type
    render :action => 'receipt'
  end

  def default_condition
    "created_at"
  end
end
