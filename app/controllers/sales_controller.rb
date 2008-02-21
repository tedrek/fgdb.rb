class SalesController < TransactionController
  before_filter :be_a_sale
  def index
    sales
  end

  protected

  def update_params_filter
  end

  def be_a_sale
    set_transaction_type( 'sale' )
  end

end
