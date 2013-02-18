class SalesController < TransactionController
  public

  def show
    @txn = @transaction = model.find(params[:id])
    @context = @transaction_type
    render :action => 'receipt'
  end

  def default_condition
    "created_at"
  end
end
