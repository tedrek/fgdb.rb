class RecyclingsController < TransactionController
  before_filter :be_a_recycling
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "recycled_at"
  end

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

  def management_only
    requires_role(:ROLE_BEAN_COUNTER)
  end

end
