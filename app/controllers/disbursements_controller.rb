class DisbursementsController < TransactionController
  before_filter :be_a_disbursement
  def index
    disbursements
  end

  protected

  def update_params_filter
  end

  def be_a_disbursement
    set_transaction_type( 'disbursement' )
  end

end
