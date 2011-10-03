#!/usr/bin/ruby

module CashiersHelper
  def cashierable
    params[:controller].classify.constantize.cashierable
  end

  def cashiers_field(force = false, pass_in = nil)
    pass_in = pass_in.nil? ? "null" : "'#{pass_in}'"
    "<label for=\"cashier_code\">Cashier Code:</label><input name=\"cashier_code\" type=\"password\" id=\"cashier_code\" onKeyUp=\"update_cashier_code(#{pass_in})\" autocomplete=\"off\"/>#{loading_indicator_tag("cashier_loading")}" if cashierable or force
  end

  def cashiers_javascript(force = false, pass_in = nil)
    pass_in = pass_in.nil? ? "null" : "'#{pass_in}'"
    javascript_tag "update_cashier_code(#{pass_in});" if cashierable or force
  end
end
