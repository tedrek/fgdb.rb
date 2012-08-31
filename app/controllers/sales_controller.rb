class SalesController < TransactionController
  protected

  private
  def get_required_privileges
    a = super
    a = a.select{|x| x[:only].nil? or x[:only] != ["/show_created_and_updated_by"]}
    a << {:only => ["/show_created_and_updated_by"], :privileges => ['role_store_admin']}
    return a
  end

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
