class DonationsController < TransactionController
  before_filter :be_a_donation
  def index
    donations
  end

  protected

  def update_params_filter
  end

  def be_a_donation
    set_transaction_type( 'donation' )
  end

end
