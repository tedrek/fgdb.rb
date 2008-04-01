module TransactionHelper
  include ApplicationHelper

  def base_controller
    raise RuntimeError.new('You best stop using /transactions')
  end

  def my_number_to_currency(value)
    number_to_currency(value.to_f/100.0)
  end

  def totals_id(context)
    "totals_div"
  end
end
