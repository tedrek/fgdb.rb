class DisbursementsController < TransactionController
  before_filter :be_a_disbursement

  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def index
    update_params_filter()
    render :action => 'listing'
  end

  protected

  def authorized_only
    requires_role('ROLE_CONTACT_MANAGER', 'ROLE_FRONT_DESK', 'ROLE_STORE', 'ROLE_VOLUNTEER_MANAGER')
  end

  def management_only
    requires_role(:ROLE_BEAN_COUNTER)
  end

  def update_params_filter
  end

  def be_a_disbursement
    set_transaction_type( 'disbursement' )
  end

end
