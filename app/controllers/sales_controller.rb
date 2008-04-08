class SalesController < TransactionController
  before_filter :be_a_sale
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

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

  def management_only
    requires_role('ROLE_STORE_ADMIN', 'ROLE_BEAN_COUNTER')
  end
end
