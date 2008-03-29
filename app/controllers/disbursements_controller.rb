class DisbursementsController < TransactionController
  before_filter :be_a_disbursement

  before_filter :authorized_only
  def authorized_only
    requires_role('ROLE_CONTACT_MANAGER', 'ROLE_FRONT_DESK', 'ROLE_STORE', 'ROLE_VOLUNTEER_MANAGER')
  end

  def index
    update_params_filter()
    render :action => 'listing'
  end

  protected

  def update_params_filter
  end

  def be_a_disbursement
    set_transaction_type( 'disbursement' )
  end

end
