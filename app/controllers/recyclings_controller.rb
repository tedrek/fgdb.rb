class RecyclingsController < TransactionController
  def default_condition
    "recycled_at"
  end

  protected
  def get_required_privileges
    a = super
    a << {:except => ["destroy", "edit", "update"], :privileges => ['role_recyclings', 'role_front_desk']}
    a << {:only => ["destroy", "edit", "update"], :privileges => ['role_bean_counter']}
    a
  end
end
