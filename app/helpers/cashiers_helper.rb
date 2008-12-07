#!/usr/bin/ruby

module CashiersHelper
  def cashierable
    params[:controller].classify.constantize.cashierable
  end

  def cashiers_field
    "<label for=\"cashier_code\">Cashier Code:</label><input name=\"cashier_code\" id=\"cashier_code\" onKeyUp=\"update_cashier_code()\"/>" if cashierable
  end

  def cashiers_javascript
    javascript_tag "update_cashier_code();" if cashierable
  end
end
