class RecyclingsController < TransactionController
  before_filter :be_a_recycling

  def index
    update_params_filter()
    render :action => 'listing'
  end

  protected

  def update_params_filter
  end

  def be_a_recycling
    set_transaction_type( 'recycling' )
  end

end
