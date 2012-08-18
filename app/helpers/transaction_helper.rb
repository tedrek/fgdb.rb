module TransactionHelper
  include ApplicationHelper

  def base_controller
    raise RuntimeError.new('You best stop using /transactions')
  end

  def totals_id(context)
    "totals_div"
  end
end
