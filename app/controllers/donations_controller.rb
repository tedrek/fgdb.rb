class DonationsController < TransactionController
  before_filter :be_a_donation
  before_filter :authorized_only

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
