class DonationsController < TransactionController
  before_filter :be_a_donation
  before_filter :authorized_only, :except => ["destroy", "edit", "update"]
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def index
    update_params_filter()
    render :action => 'listing'
  end

  protected

  def authorized_only
    requires_role(:ROLE_FRONT_DESK)
  end

  def management_only
    requires_role(:ROLE_DONATION_ADMIN, :ROLE_BEAN_COUNTER)
  end

  def update_params_filter
  end

  def be_a_donation
    set_transaction_type( 'donation' )
  end

end
