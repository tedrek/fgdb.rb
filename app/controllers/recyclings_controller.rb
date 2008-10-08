class RecyclingsController < TransactionController
  before_filter :management_only, :only => ["destroy", "edit", "update"]

  def default_condition
    "recycled_at"
  end

  protected

  def management_only
    requires_role(:BEAN_COUNTER)
  end
end
