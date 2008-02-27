class SalesController < TransactionController
  before_filter :be_a_sale
  before_filter :authorized_only

  def index
    update_params_filter()
    render :action => 'listing'
  end

  protected

  def update_params_filter
  end

  def be_a_sale
    set_transaction_type( 'sale' )
  end

  def authorized_only
    requires_role('ROLE_STORE')
  end
end
